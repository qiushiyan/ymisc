const esbuild = require("esbuild");
const path = require("path");

esbuild
  .build({
    entryPoints: [path.join(__dirname, "srcts/index.ts")],
    bundle: true,
    outfile: path.join(__dirname, "inst/htmlwidgets/example.js"),
    platform: "node",
    format: "cjs",
    external: ["Shiny", "HTMLWidgets"],
    watch: {
      onRebuild(error, result) {
        if (error) console.error("watch build failed:", error);
        else console.log("watch build succeeded:", result);
      },
    },
    sourcemap: true,
  })
  .catch((err) => {
    process.stderr.write(err.stderr);
    process.exit(1);
  });
