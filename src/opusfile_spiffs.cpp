#include "opusfile_spiffs.hpp"

namespace Palatis {

OpusFileCallbacks OpusFileSPIFFS::_spiffs_cb;

int OpusFileSPIFFS::_spiffs_read_func(fs::File * file, unsigned char * ptr, int nbytes) {
    return file->read(ptr, nbytes);
}

int OpusFileSPIFFS::_spiffs_seek_func(fs::File * file, opus_int64 offset, int whence) {
    SeekMode mode = fs::SeekMode::SeekSet;
    if (whence == SEEK_CUR)
        mode = fs::SeekMode::SeekCur;
    if (whence == SEEK_END)
        mode = fs::SeekMode::SeekEnd;

    return file->seek(offset, mode) ? 0 : -1;
}

int OpusFileSPIFFS::_spiffs_tell_func(fs::File * file) {
    return file->position();
}

ICACHE_FLASH_ATTR
int OpusFileSPIFFS::_spiffs_close_func(fs::File * file) {
    file->close();
    return 0;
}

}
