HTMLWidgets.widget({
  name: "widgetexample",

  type: "output",

  factory: function (el: HTMLElement, width: number, height: number) {
    // TODO: define shared variables for this instance

    return {
      renderValue: function (payload) {},

      resize: function (width: number, height: number) {
        // TODO: code to re-render the widget with a new size
      },
    };
  },
});
