#!/usr/bin/env python3
import http.server
import os
import socketserver
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
BUILD_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'build', 'web')

class SPANoCacheHTTPHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=BUILD_DIR, **kwargs)

    def send_head(self):
        # Resolve path within build directory
        path = self.translate_path(self.path)
        # If file doesn't exist or is a directory with no index, fallback to /index.html for SPA routing
        if not os.path.exists(path) or (os.path.isdir(path) and not any(os.path.isfile(os.path.join(path, idx)) for idx in self.index_pages)):
            self.path = '/index.html'
        return super().send_head()

    def end_headers(self):
        # Disable caching during local testing
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

if __name__ == '__main__':
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), SPANoCacheHTTPHandler) as httpd:
        print(f"Serving Barter Web App at http://localhost:{PORT}")
        print(f"Build Directory: {BUILD_DIR}")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nShutting down server.")
