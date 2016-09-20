/**
 * Copyright 2016 Victor Tseng <palatis@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __ARDUINO_OPUS_HPP
#define __ARDUINO_OPUS_HPP

#include <FS.h>
#include <opusfile.h>

namespace Palatis {

class OpusFileSPIFFS {
public:
    OpusFileSPIFFS():
        _file(), _opusfile(nullptr)
    { }

    OpusFileSPIFFS(const char * path) {
        open(path);
    }

    void open(const char * path) {
        _file = SPIFFS.open(path, "r");

        _spiffs_cb.read = reinterpret_cast<op_read_func>(_spiffs_read_func);
        _spiffs_cb.seek = reinterpret_cast<op_seek_func>(_spiffs_seek_func);
        _spiffs_cb.tell = reinterpret_cast<op_tell_func>(_spiffs_tell_func);
        _spiffs_cb.close = reinterpret_cast<op_close_func>(_spiffs_close_func);

        int error = 0;
        _opusfile = op_open_callbacks(&_file, &_spiffs_cb, nullptr, 0, &error);
        if (error) {
            op_free(_opusfile);
            _opusfile = nullptr;
            _file.close();
        }
    }

    int read(opus_int16 * pcm, int buf_size) {
        return op_read(_opusfile, pcm, buf_size, nullptr);
    }

    int read_float(float * pcm, int buf_size) {
        return op_read_float(_opusfile, pcm, buf_size, nullptr);
    }

    int read_stereo(opus_int16 * pcm, int buf_size) {
        return op_read_stereo(_opusfile, pcm, buf_size);
    }

    int read_float_stereo(float * pcm, int buf_size) {
        return op_read_float_stereo(_opusfile, pcm, buf_size);
    }

    bool available() {
        return _file.available();
    }

    ~OpusFileSPIFFS() {
        op_free(_opusfile);
        _opusfile = nullptr;
        _file.close();
    }

private:
    fs::File _file;
    OggOpusFile * _opusfile;
    OpusFileCallbacks _spiffs_cb;

    static int _spiffs_read_func(fs::File * file, unsigned char * ptr, int nbytes);
    static int _spiffs_seek_func(fs::File * file, opus_int64 offset, int whence);
    static int _spiffs_tell_func(fs::File * file);
    static int _spiffs_close_func(fs::File * file);
};

}

#endif // __ESP8266_ARDUINO_OPUS_HPP
