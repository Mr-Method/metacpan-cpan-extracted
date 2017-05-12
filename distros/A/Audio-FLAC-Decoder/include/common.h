/* 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

#ifdef min
#undef min
#endif
#define min(x,y) ((x)<(y)?(x):(y))

#ifdef max
#undef max
#endif
#define max(a,b) ((a)>(b)?(a):(b))

#ifdef WORDS_BIGENDIAN
#define host_is_big_endian() TRUE
#else
#define host_is_big_endian() FALSE
#endif

#if defined _MSC_VER
#define FLAC__INLINE __inline
#else
#define FLAC__INLINE
#endif

#define FLAC__MAX_SUPPORTED_CHANNELS 2
