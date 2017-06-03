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
 *
 * Original source file: https://github.com/needle-and-thread/vocal/blob/master/src/Services/ImageCache.vala
 * Additional contributors/authors: Akshay Shekher <voldyman666@gmail.com>
 */

namespace Gradio {

	public class ImageCache : GLib.Object {

		private static Soup.Session session;

		public ImageCache() {
			session = new Soup.Session();
			session.user_agent = "gradio/"+ Config.VERSION;
		}

		public async Gdk.Pixbuf get_image(string url) {
			uint url_hash = url.hash();
		    	Gdk.Pixbuf pixbuf = null;

			if(is_image_cached(url_hash)){
			 	pixbuf = get_cached_image(url_hash);
			}else{
			 	pixbuf = yield get_image_from_url(url);
			 	cache_image(pixbuf, url_hash);
			}

		    	return pixbuf;
		}

		private bool is_image_cached(uint hash){
			return FileUtils.test (GLib.Environment.get_user_cache_dir()+"/gradio/"+hash.to_string()+".png", FileTest.EXISTS);
		}

		private Gdk.Pixbuf get_cached_image(uint hash){
			Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file(GLib.Environment.get_user_cache_dir()+"/gradio/"+hash.to_string()+".png");
			return pixbuf;
		}

		private async void cache_image(Gdk.Pixbuf pixbuf, uint hash){
			var file_location = "%s/%u.png".printf(GLib.Environment.get_user_cache_dir()+"/gradio/", hash);
                	var cfile = File.new_for_path(file_location);
			FileIOStream fiostream = null;

			try{
		        	if (cfile.query_exists()) {
		            		fiostream = yield cfile.replace_readwrite_async(null, false, FileCreateFlags.NONE);
		        	} else {
		            		fiostream = yield cfile.create_readwrite_async(FileCreateFlags.NONE);
		        	}
			}catch (Error e){}

                	yield pixbuf.save_to_stream_async(fiostream.get_output_stream(), "png");
		}

		private async Gdk.Pixbuf get_image_from_url(string url){
			Gdk.Pixbuf pixbuf = null;
        		InputStream image_stream = null;
            		Soup.Request req = null;

			req = session.request(url);
            		image_stream = yield req.send_async(null);
            		pixbuf = yield new Gdk.Pixbuf.from_stream_async(image_stream, null);

			return pixbuf;
		}
    }

}