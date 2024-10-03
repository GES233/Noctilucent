// 查阅进阶用法，请看 Tailwind 配置引导
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/noctilucent_web.ex",
    "../lib/noctilucent_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        // 这是 Phoenix 自带的
        brand: "#FD4F00",

        // 以下是业务相关的，其格式为 `ncl_bla_bla`
        // （几乎是）黑色的天空
        ncl_bg: "#19193D",
        // 暮辉光
        ncl_twi: "#F1C376",
        ncl_twi_light: "#E2DAB5",
        // 云的本身
        ncl_cl: "#7F8AA6",
        ncl_cl_light: "#A0A1A5",
        ncl_twi_cl: "#F1EFDA",
        // 彩云
        ncl_cl_pr: "#C4ABE2",
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // 允许使用 LiveView 类作为 tailwind 类的前缀，以便仅在应用 LiveView 类时添加规则，例如：
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // 将 Heroicons (https://heroicons.com) 嵌入到你应用的 app.css 的一堆里
    // 欲获得更多信息，请查看 `CoreComponents.icon/1` 的文档。
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../../../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ]
}
