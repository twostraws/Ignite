import http.server
import socketserver
import os

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def send_error(self, code, message=None, explain=None):
        if code == 404:
            self.error_message_format = ""
            error_page = os.path.join(os.getcwd(), '404.html')
            if os.path.exists(error_page):
                self.send_response(404)
                self.send_header('Content-Type', 'text/html')
                self.end_headers()
                with open(error_page, 'rb') as f:
                    self.wfile.write(f.read())
            else:
                super().send_error(404, "File not found", "The requested URL was not found on this server")
        else:
            super().send_error(code, message, explain)

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--directory', '-d', default=os.getcwd())
    parser.add_argument('port', nargs='?', type=int, default=8000)
    args = parser.parse_args()
    
    os.chdir(args.directory)
    with socketserver.TCPServer(("", args.port), CustomHandler) as httpd:
        print(f"Serving {args.directory} at port {args.port}")
        httpd.serve_forever()