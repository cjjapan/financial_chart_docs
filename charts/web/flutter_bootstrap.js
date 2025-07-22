{{flutter_js}}
{{flutter_build_config}}

let _flutterActiveViews = [];

function _recreateFlutterViews(app, theme) {
  for(const viewId of _flutterActiveViews) {
    app.removeView(viewId);
  }
  _flutterActiveViews = [];
  const chartViews = document.querySelectorAll("div.f-chart");
  for (const chartView of chartViews) {
    const name = chartView.getAttribute("data-chart-name");
    const ticker = chartView.getAttribute("data-chart-ticker");
    if (name) {
      const viewId = app.addView({
        hostElement: chartView,
          initialData: {
          name: name,
          ticker: ticker,
          theme: theme || "light",
        }
      });
      _flutterActiveViews.push(viewId);
    }
  }
}

function _listenToThemeChange(app) {
  const target = document.querySelector("html");
  if (target) {
    _recreateFlutterViews(app, target.getAttribute("data-theme") || "light");
    var observer = new MutationObserver(function (mutations) {
      mutations.forEach(function (mutation) {
        if (mutation.type === "attributes" && mutation.attributeName === "data-theme") {
          _recreateFlutterViews(app, target.getAttribute("data-theme"));
        }
      });
    });
    observer.observe(target, { attributes: true });
  }
}

_flutter.loader.load({
  config: {
    entryPointBaseUrl: '/chart-demo/'
  },
  onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
  let engine = await engineInitializer.initializeEngine({
    multiViewEnabled: true,
    assetBase: '/chart-demo/',
  });
  let app = await engine.runApp();
  _listenToThemeChange(app);
  }
});

