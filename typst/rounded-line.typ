#import "@preview/cetz:0.5.3"

/// Draw a line strip with circular, tangent corners.
///
/// Positional arguments are CeTZ coordinates. `radius` is a non-negative
/// canvas-unit number or absolute length. Each corner's radius is reduced as
/// needed so its tangent points occupy at most half of each adjoining segment.
/// Straight, repeated, and reversing points remain sharp. Rounded corners
/// require their three points to lie in the same z plane.
///
/// `close`, `name`, and line styles (including marks) are forwarded to the
/// merged path. Named coordinates resolve to anchors; unlike `cetz.draw.line`,
/// bare element names do not automatically intersect the element's border.
/// The result exposes merge-path's anchors rather than line's point anchors.
#let rounded-line(..points-style, radius: 0.2, close: false, name: none) = {
  let points = points-style.pos()
  let style = points-style.named()
  assert(points.len() >= if close { 3 } else { 2 },
    message: "rounded-line requires at least two points (three when closed)")

  // A CeTZ element runs with the canvas context, so coordinates and lengths
  // are resolved here rather than when rounded-line is called. Resolving all
  // points in order also preserves relative-coordinate semantics.
  (ctx => {
    let r = cetz.util.resolve-number(ctx, radius)
    assert(r >= 0, message: "rounded-line radius must be non-negative")
    let (ctx, ..pts) = cetz.coordinate.resolve(ctx, ..points)
    let n = pts.len()
    // Record the geometry for each vertex first. `none` means the vertex
    // remains sharp; open paths also leave their two endpoints untouched.
    let corners = ()
    for i in range(n) {
      let p = pts.at(i)
      let corner = none
      if (close or (i > 0 and i < n - 1)) and r > 0 {
        // Wrap the neighbours for closed paths, including vertex zero.
        let a = pts.at(calc.rem(i + n - 1, n))
        let b = pts.at(calc.rem(i + 1, n))
        assert(a.at(2) == p.at(2) and b.at(2) == p.at(2),
          message: "rounded-line corners must lie in a constant z plane")
        let (dx1, dy1) = (p.at(0) - a.at(0), p.at(1) - a.at(1))
        let (dx2, dy2) = (b.at(0) - p.at(0), b.at(1) - p.at(1))
        let l1 = calc.sqrt(dx1 * dx1 + dy1 * dy1)
        let l2 = calc.sqrt(dx2 * dx2 + dy2 * dy2)
        // A repeated point has no direction and cannot define a tangent.
        if l1 > 0 and l2 > 0 {
          let (ux, uy) = (dx1 / l1, dy1 / l1)
          let (vx, vy) = (dx2 / l2, dy2 / l2)
          // Unit vectors point along the incoming and outgoing segments.
          // The cross product gives the turn's sign; the dot product gives
          // its cosine. Near-collinear and reversing segments stay sharp.
          let cross = ux * vy - uy * vx
          let dot = ux * vx + uy * vy
          if calc.abs(cross) > 0.000001 {
            // Typst's atan2 takes (x, y). The signed turn is the arc sweep.
            // A radius r and turn theta place each tangent point at distance
            // r * tan(|theta| / 2) from the vertex along its segment.
            let turn = calc.atan2(dot, cross)
            let factor = calc.abs(calc.tan(turn / 2))
            // Limit each corner to half of each adjoining segment, so two
            // neighbouring rounded corners cannot overlap. Recompute the
            // radius from the shortened tangent distance to retain tangency.
            let distance = calc.min(r * factor, l1 / 2, l2 / 2)
            let actual-radius = distance / factor
            let start = (p.at(0) - ux * distance, p.at(1) - uy * distance, p.at(2))
            // The radius vector at the arc start is perpendicular to the
            // incoming direction: right for a left turn, left for a right turn.
            let angle = calc.atan2(ux, uy) - if cross > 0 { 90deg } else { -90deg }
            corner = (start: start, angle: angle, turn: turn, radius: actual-radius)
          }
        }
      }
      corners.push(corner)
    }

    let parts = ()
    // merge-path concatenates these pieces into one continuous stroked path.
    // Each entry consists of a straight segment followed by an optional arc.
    // Start at vertex zero, or at its outgoing tangent for a closed path.
    let start = if close and corners.first() != none {
      // Recover the circle center from the incoming tangent and radius vector,
      // then rotate that vector through the turn to get the outgoing tangent.
      // Starting there lets the final iteration draw vertex zero's arc last.
      let c = corners.first()
      let center = (c.start.at(0) - c.radius * calc.cos(c.angle),
                    c.start.at(1) - c.radius * calc.sin(c.angle), c.start.at(2))
      (center.at(0) + c.radius * calc.cos(c.angle + c.turn),
       center.at(1) + c.radius * calc.sin(c.angle + c.turn), center.at(2))
    } else { pts.first() }
    let previous = start
    // Visit vertex zero again only when closing, to include its corner arc.
    let indices = if close { range(1, n + 1) } else { range(1, n) }
    for index in indices {
      let i = calc.rem(index, n)
      let c = corners.at(i)
      let next = if c == none { pts.at(i) } else { c.start }
      // Suppress marks on individual pieces; they belong on the merged path.
      parts += cetz.draw.line(previous, next, mark: none)
      if c != none {
        parts += cetz.draw.arc(c.start, start: c.angle, delta: c.turn,
          radius: c.radius, mode: "OPEN", mark: none)
        // Advance to the outgoing tangent point, using the same circle-center
        // calculation as above, so the next straight segment starts at the arc.
        let center = (c.start.at(0) - c.radius * calc.cos(c.angle),
                      c.start.at(1) - c.radius * calc.sin(c.angle), c.start.at(2))
        previous = (center.at(0) + c.radius * calc.cos(c.angle + c.turn),
                    center.at(1) + c.radius * calc.sin(c.angle + c.turn), center.at(2))
      } else {
        previous = next
      }
    }
    // merge-path normally resolves the global style, whereas line uses the
    // `line` style root. Resolve that root explicitly to preserve line styling,
    // then apply marks once to the finished path rather than to each piece.
    let line-style = cetz.styles.resolve(ctx.style, merge: style, root: "line")
    let merged = cetz.draw.merge-path(parts, close: close, name: name,
      stroke: line-style.stroke, fill: line-style.fill,
      fill-rule: line-style.fill-rule, mark: line-style.mark)
    // Return the merged element's result directly so its name, path anchors,
    // drawables, and updated context are exposed as the rounded-line result.
    merged.first()(ctx)
  },)
}
