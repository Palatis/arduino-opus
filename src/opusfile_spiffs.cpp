#include <FS.h>

#include "opusfile_spiffs.hpp"

namespace Palatis {

int OpusFileSPIFFS::_spiffs_read_func(fs::File * file, unsigned char * ptr, int nbytes) {
    if(ptr == nullptr || nbytes <= 0)
        return 0;
    size_t ret = file->read(ptr, nbytes);
    return ret > 0 || file->available() ? (int)ret : OP_EREAD;
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

int OpusFileSPIFFS::_spiffs_close_func(fs::File * file) {
    file->close();
    return 0;
}

}
