nginx-lua-ds-fileupload
=======================

A file upload module for web developing based on openresty/lua-resty-upload and hayageek/jquery-upload-file

nginx configure

        location = /upload {
            if ( $request_method = GET ){
                root   html;
            }
            if ( $request_method = POST ){
                content_by_lua_file lua/upload.lua;
            }
            index  index.html;
        }
