return {
    'aserowy/tmux.nvim',
    opts = {
        navigation = {
            cycle_navigation = false,
            enable_default_keybindings = true,

            -- prevents unzoom tmux when navigating beyond vim border

            persist_zoom = false,
        },
        resize = {
            enable_default_keybindings = true,
            resize_step_x = 4,
            resize_step_y = 4,
        }
    },
}
