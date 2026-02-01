// 3column-center-focus.js
//
// Layout:
// [ left |   MAIN (center focus)   | right ]
//
// Behavior:
// - windows[0] is the "main" window and stays in the center column.
// - remaining windows are alternated into left and right columns.
// - each column stacks its windows vertically.

function layout() {
  // Tune this for “more focused” center:
  // - 0.60 = strong focus, still usable side gutters
  // - 0.66 = very focused center
  const MAIN_WIDTH_RATIO = 0.62;

  function stackVertically(windows, frame) {
    const n = windows.length;
    if (n === 0) return {};

    const h = frame.height / n;
    return windows.reduce((acc, w, i) => {
      acc[w.id] = {
        x: frame.x,
        y: frame.y + i * h,
        width: frame.width,
        height: h,
      };
      return acc;
    }, {});
  }

  return {
    name: "3Column Center Focus",
    getFrameAssignments: (windows, screenFrame) => {
      if (!windows || windows.length === 0) return {};

      // Optional: on small screens, fall back to a simpler split
      // (feel free to delete this block)
      if (screenFrame.width < 1400) {
        const mainW = screenFrame.width * 0.55;
        const sideW = screenFrame.width - mainW;

        const mainFrame = {
          x: screenFrame.x,
          y: screenFrame.y,
          width: mainW,
          height: screenFrame.height,
        };

        const sideFrame = {
          x: screenFrame.x + mainW,
          y: screenFrame.y,
          width: sideW,
          height: screenFrame.height,
        };

        const mainWindow = windows[0];
        const rest = windows.slice(1);

        return {
          [mainWindow.id]: mainFrame,
          ...stackVertically(rest, sideFrame),
        };
      }

      // 3-column math
      const mainW = screenFrame.width * MAIN_WIDTH_RATIO;
      const sideW = (screenFrame.width - mainW) / 2;

      const leftFrame = {
        x: screenFrame.x,
        y: screenFrame.y,
        width: sideW,
        height: screenFrame.height,
      };

      const mainFrame = {
        x: screenFrame.x + sideW,
        y: screenFrame.y,
        width: mainW,
        height: screenFrame.height,
      };

      const rightFrame = {
        x: screenFrame.x + sideW + mainW,
        y: screenFrame.y,
        width: sideW,
        height: screenFrame.height,
      };

      // Assign windows
      const mainWindow = windows[0];
      const rest = windows.slice(1);

      const left = [];
      const right = [];
      rest.forEach((w, i) => {
        (i % 2 === 0 ? left : right).push(w);
      });

      return {
        [mainWindow.id]: mainFrame,
        ...stackVertically(left, leftFrame),
        ...stackVertically(right, rightFrame),
      };
    },
  };
}

module.exports = layout();

