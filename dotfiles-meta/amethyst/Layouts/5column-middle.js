// 5column-middle.js
//
// Layout:
// [ outerLeft | innerLeft |  MAIN  | innerRight | outerRight ]
//
// Notes:
// - windows[0] is treated as the "main" window (center column).
// - Remaining windows are distributed to side columns starting near the center.
// - Each column stacks its assigned windows vertically.
//
// Tweak ratios below for your ultrawide.

function layout() {
  const ratios = {
    main: 0.34,      // center column width
    inner: 0.20,     // inner side columns width (left/right)
    outer: 0.13      // outer side columns width (leftmost/rightmost)
  };

  // Ensure ratios sum to ~1.0. If you change them, keep:
  // ratios.main + 2*ratios.inner + 2*ratios.outer === 1.0

  function stackVertically(windows, frame) {
    const n = windows.length;
    if (n === 0) return {};
    const h = frame.height / n;

    return windows.reduce((acc, w, i) => {
      acc[w.id] = {
        x: frame.x,
        y: frame.y + i * h,
        width: frame.width,
        height: h
      };
      return acc;
    }, {});
  }

  return {
    name: "5Column-Middle",
    // getFrameAssignments takes (windows, screenFrame, state, extendedFrames)
    // and returns { [windowId]: {x,y,width,height} } :contentReference[oaicite:2]{index=2}
    getFrameAssignments: (windows, screenFrame) => {
      if (!windows || windows.length === 0) return {};

      // Compute column frames left -> right
      const outerW = screenFrame.width * ratios.outer;
      const innerW = screenFrame.width * ratios.inner;
      const mainW  = screenFrame.width * ratios.main;

      const x0 = screenFrame.x;

      const framesByColumn = {
        outerLeft:  { x: x0,                           y: screenFrame.y, width: outerW, height: screenFrame.height },
        innerLeft:  { x: x0 + outerW,                  y: screenFrame.y, width: innerW, height: screenFrame.height },
        main:       { x: x0 + outerW + innerW,         y: screenFrame.y, width: mainW,  height: screenFrame.height },
        innerRight: { x: x0 + outerW + innerW + mainW, y: screenFrame.y, width: innerW, height: screenFrame.height },
        outerRight: { x: x0 + outerW + innerW + mainW + innerW, y: screenFrame.y, width: outerW, height: screenFrame.height }
      };

      // Assign windows to columns
      const mainWindow = windows[0];
      const rest = windows.slice(1);

      const cols = {
        main: [mainWindow],
        innerLeft: [],
        innerRight: [],
        outerLeft: [],
        outerRight: []
      };

      // Fill near-center first for better ergonomics on ultrawide:
      // innerLeft, innerRight, outerLeft, outerRight, repeat
      const order = ["innerLeft", "innerRight", "outerLeft", "outerRight"];
      rest.forEach((w, i) => {
        cols[order[i % order.length]].push(w);
      });

      // Build final window->frame mapping
      return {
        ...stackVertically(cols.outerLeft,  framesByColumn.outerLeft),
        ...stackVertically(cols.innerLeft,  framesByColumn.innerLeft),
        ...stackVertically(cols.main,       framesByColumn.main),
        ...stackVertically(cols.innerRight, framesByColumn.innerRight),
        ...stackVertically(cols.outerRight, framesByColumn.outerRight)
      };
    }
  };
}

module.exports = layout();

