/* This file is part of Gradio.
 *
 * Gradio is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Gradio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Gradio.  If not, see <http://www.gnu.org/licenses/>.
 */


using Gtk;

namespace Gradio{
	public enum WindowMode {
		LIBRARY,
		DISCOVER,
		SEARCH,
		DETAILS,
		SETTINGS,
		LOADING
	}

	public class BackEntry{
		public WindowMode mode;
		public DataWrapper data;
	}

	// one class, but can contain different types. Used in MainWindow class for change_mode
	public class DataWrapper{
		public RadioStation station {get;set;}
		public string search {get;set;}
	}


	public class Util{

		public static async string get_string_from_uri (string url){
			if(url != ""){
				var session = new Soup.SessionAsync ();
				session.user_agent = "gradio/"+ Config.VERSION;
				var message = new Soup.Message ("GET", url);

				session.queue_message (message, (session, msg) => {
		        		get_string_from_uri.callback ();
		    		});
				yield;

				if((string)message.response_body.data != null){
					return (string)message.response_body.data;
				}

			}
			return "";
		}

		public static void remove_all_items_from_list_box (Gtk.ListBox container) {
			container.foreach(remove_all_cb);
		}

		public static void remove_all_items_from_flow_box (Gtk.FlowBox container) {
			container.foreach(remove_all_cb);
		}

		public static void remove_all_items_from_box (Gtk.Box container) {
			container.foreach(remove_all_cb);
		}

		private static void remove_all_cb(Gtk.Widget w){
			w.destroy();
		}

		public static void show_info_dialog(string text, Gtk.Window parent){
			Gtk.MessageDialog msg = new Gtk.MessageDialog (parent, Gtk.DialogFlags.MODAL, Gtk.MessageType.WARNING, Gtk.ButtonsType.OK, text);
				msg.response.connect ((response_id) => {
				msg.destroy();
			});
			msg.show ();
		}

		public static string optimize_string(string str){
			string s = str;

			while(s.get_char(s.length -1) == ' '){
				s = s.substring(0, s.length-1);
			}

			return s;
		}

		public static bool check_database_connection(){
			var host = "www.radio-browser.info";

			try {
				Resolver resolver = Resolver.get_default ();
				resolver.lookup_by_name (host, null);
				return true;
			} catch (Error e) {
				critical (e.message);
				return false;
			}
		}

		public static void open_website(string address){
			try{
				Gtk.show_uri(null, address, 0);
			}catch(Error e){
				error("Cannot open website. " + e.message);
			}

		}

		public static void add_stylesheet () {
			var provider = new CssProvider ();

			provider.load_from_resource ("/de/haecker-felix/gradio/de.haeckerfelix.gradio.style.css");
			StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
			message("Loaded from /de/haecker-felix/gradio/de.haeckerfelix.gradio.style.css");
		}

		public static void send_notification(string summary, string body, Gdk.Pixbuf? icon = null){
			var notification = new GLib.Notification (summary);
			notification.set_body (body);
			GLib.Application.get_default ().send_notification ("de.haeckerfelix.gradio", notification);
		}

		public static void optiscale (ref Gdk.Pixbuf pixbuf, int size) {
			double pixb_w = pixbuf.get_width();
			double pixb_h = pixbuf.get_height();

			if((pixb_w > size) || (pixb_h > size)){
				double sc_factor_w = size / pixb_w;
				double sc_factor_h = size / pixb_h;

				double sc_factor = 0;

				if(sc_factor_w >= sc_factor_h)
					sc_factor = sc_factor_h;
				if(sc_factor_h >= sc_factor_w)
					sc_factor = sc_factor_w;

				double sc_w = pixb_w * sc_factor;
				double sc_h = pixb_h * sc_factor;

				pixbuf = pixbuf.scale_simple ((int)sc_w, (int)sc_h, Gdk.InterpType.BILINEAR);
			}
		}
	}
}

