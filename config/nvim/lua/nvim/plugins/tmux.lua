return {
    'aserowy/tmux.nvim',
    opts = {
        copy_sync = {
            enable = false,
            ignore_buffers = { empty = false },
            redirect_to_clipboard = true,
            register_offset = 0,
            sync_clipboard = true,
            sync_registers = true,
            sync_deletes = true,
            sync_unnamed = true,
        },
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
