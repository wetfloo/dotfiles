return {
    "jesseleite/nvim-noirbuddy",
    dependencies = {
        { "tjdevries/colorbuddy.nvim", branch = "master" },
    },
    lazy = false,
    priority = 1000,
    opts = {
        colors = {
            primary = "#d6bfff",
            secondary = "#adf5ff",
            background = "#000000",

            diagnostic_error = "#ff474a",
            diagnostic_warning = "#ffe561",
            diagnostic_info = "#61fffc",
            diagnostic_hint = "#61fffc",

            diff_add = "#1aff85",
            diff_change = "#adf5ff",
            diff_delete = "#ff6183",
        },
    },
}
