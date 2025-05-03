import http.server
import socketserver
import os
import sys

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, directory=None, subsite=None, **kwargs):
        self.base_directory = directory or os.getcwd()
        self.subsite = None if subsite == '/' else subsite
        super().__init__(*args, directory=self.base_directory, **kwargs)
        
    def translate_path(self, path):
        # Remove the subsite from the requested path
        if self.subsite and path.startswith(self.subsite):
            path = path[len(self.subsite):]
            
        return super().translate_path(path)
    
    def do_GET(self):
        # Redirect root request if subsite is specified
        if self.subsite and self.path == '/':
            self.send_response(301)
            self.send_header('Location', self.subsite)
            self.end_headers()
            return
        
        super().do_GET()

    def send_error(self, code, message=None, explain=None):
        if code == 404:
            error_page = os.path.join(self.base_directory, '404.html')
            if os.path.exists(error_page):
                self.send_response(404)
                self.send_header('Content-Type', 'text/html')
                self.end_headers()
                with open(error_page, 'rb') as f:
                    self.wfile.write(f.read())
                return
        super().send_error(code, message, explain)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--directory', '-d', default=os.getcwd())
    parser.add_argument('--subsite', '-s', default=None)
    parser.add_argument('port', nargs='?', type=int, default=8000)
    args = parser.parse_args()

    if not os.path.exists(args.directory):
        print(f"Error: Directory '{args.directory}' does not exist")
        sys.exit(1)

    with socketserver.TCPServer(("", args.port), lambda *a, **kw: CustomHandler(*a, directory=args.directory, subsite=args.subsite, **kw)) as httpd:
        print(f"Serving {args.directory} at port {args.port}")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped")