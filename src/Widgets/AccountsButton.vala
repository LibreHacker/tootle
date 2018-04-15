using Gtk;

public class Tootle.AccountsButton : Gtk.MenuButton{

    Granite.Widgets.Avatar avatar;
    Gtk.Grid grid;
    Gtk.Popover menu;
    AccountView default_account;

    private class AccountView : Gtk.Grid{
    
        public Gtk.Label name;
        public Gtk.Label user;
        public Gtk.Button logout;
    
        construct {
            margin = 6;
            margin_start = 14;
        
            name = new Gtk.Label ("<b>Anonymous</b>");
            name.hexpand = true;
            name.halign = Gtk.Align.START;
            name.use_markup = true;
            user = new Gtk.Label ("@error");
            user.halign = Gtk.Align.START;
            logout = new Gtk.Button.from_icon_name ("pane-hide-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            logout.receives_default = false;
            logout.tooltip_text = _("Log out");
            logout.clicked.connect (() => AccountManager.instance.logout ());
            show_all ();
            
            attach(name, 1, 0, 1, 1);
            attach(user, 1, 1, 1, 1);
            attach(logout, 2, 0, 2, 2);
        }
    
        public AccountView (){}
    
    }

    construct{
        avatar = new Granite.Widgets.Avatar.with_default_icon (24);
        avatar.button_press_event.connect(event => {
            return false;
        });
    
        default_account = new AccountView ();
    
        var item_separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        item_separator.hexpand = true;
    
        var item_settings = new Gtk.ModelButton ();  
        item_settings.text = _("Settings");
    
        grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.width_request = 200;
        grid.attach(default_account, 0, 1, 1, 1);
        grid.attach(item_separator, 0, 2, 1, 1);
        grid.attach(item_settings, 0, 3, 1, 1);
        grid.show_all ();
        
        menu = new Gtk.Popover (null);
        menu.add (grid);

        get_style_context ().add_class ("button_avatar");
        popover = menu;
        add(avatar);
        show_all ();
        
        AccountManager.instance.changed_current.connect (account => {
            if (account != null){
                CacheManager.instance.load_avatar (account.avatar, avatar, 24);
                default_account.name.label = "<b>"+account.display_name+"</b>";
                default_account.user.label = "@"+account.username;
            }
        });
    }

    public AccountsButton(){
        Object();
    }

}
