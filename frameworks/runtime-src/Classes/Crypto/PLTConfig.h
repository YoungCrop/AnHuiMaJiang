/* 
============================================================================================
	Utilities的平台配置

	add 2013.11.22 by yuwf

	Copyright (c), ...	

=============================================================================================
*/

#ifndef	_PALANTIR_CONFIG_H
#define	_PALANTIR_CONFIG_H

// 这里参考了qt的平台宏 将宏的前缀Q_OS-》PLT_OS

/*
   The operating system, must be one of: (PLT_OS_x)

     DARWIN   - Any Darwin system
     MAC      - OS X and iOS
     OSX      - OS X
     IOS      - iOS
     MSDOS    - MS-DOS and Windows
     OS2      - OS/2
     OS2EMX   - XFree86 on OS/2 (not PM)
     WIN32    - Win32 (Windows 2000/XP/Vista/7 and Windows Server 2003/2008)
     WINCE    - WinCE (Windows CE 5.0)
     WINRT    - WinRT (Windows 8 Runtime)
     CYGWIN   - Cygwin
     SOLARIS  - Sun Solaris
     HPUX     - HP-UX
     ULTRIX   - DEC Ultrix
     LINUX    - Linux [has variants]
     FREEBSD  - FreeBSD [has variants]
     NETBSD   - NetBSD
     OPENBSD  - OpenBSD
     BSDI     - BSD/OS
     IRIX     - SGI Irix
     OSF      - HP Tru64 UNIX
     SCO      - SCO OpenServer 5
     UNIXWARE - UnixWare 7, Open UNIX 8
     AIX      - AIX
     HURD     - GNU Hurd
     DGUX     - DG/UX
     RELIANT  - Reliant UNIX
     DYNIX    - DYNIX/ptx
     QNX      - QNX [has variants]
     QNX6     - QNX RTP 6.1
     LYNX     - LynxOS
     BSD4     - Any BSD 4.4 system
     UNIX     - Any UNIX BSD/SYSV system
     ANDROID  - Android platform

   The following operating systems have variants:
     LINUX    - both PLT_OS_LINUX and PLT_OS_ANDROID are defined when building for Android
              - only PLT_OS_LINUX is defined if building for other Linux systems
     QNX      - both PLT_OS_QNX and PLT_OS_BLACKBERRY are defined when building for Blackberry 10
              - only PLT_OS_QNX is defined if building for other QNX targets
     FREEBSD  - PLT_OS_FREEBSD is defined only when building for FreeBSD with a BSD userland
              - PLT_OS_FREEBSD_KERNEL is always defined on FreeBSD, even if the userland is from GNU
*/


#if defined(__APPLE__) && (defined(__GNUC__) || defined(__xlC__) || defined(__xlc__))
#  define PLT_OS_DARWIN
#  define PLT_OS_BSD4
#  ifdef __LP64__
#    define PLT_OS_DARWIN64
#  else
#    define PLT_OS_DARWIN32
#  endif
#elif defined(ANDROID)
#  define PLT_OS_ANDROID
#  define PLT_OS_LINUX
#elif defined(__CYGWIN__)
#  define PLT_OS_CYGWIN
#elif !defined(SAG_COM) && (!defined(WINAPI_FAMILY) || WINAPI_FAMILY==WINAPI_FAMILY_DESKTOP_APP) && (defined(WIN64) || defined(_WIN64) || defined(__WIN64__))
#  define PLT_OS_WIN64
#elif !defined(SAG_COM) && (defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__))
#  if defined(WINCE) || defined(_WIN32_WCE)
#    define PLT_OS_WINCE
#  elif defined(WINAPI_FAMILY)
#    if WINAPI_FAMILY==WINAPI_FAMILY_PHONE_APP
#      define PLT_OS_WINPHONE
#      define PLT_OS_WINRT
#    elif WINAPI_FAMILY==WINAPI_FAMILY_APP
#      define PLT_OS_WINRT
#    else
#      define PLT_OS_WIN32
#    endif
#  else
#    define PLT_OS_WIN32
#  endif
#elif defined(__sun) || defined(sun)
#  define PLT_OS_SOLARIS
#elif defined(hpux) || defined(__hpux)
#  define PLT_OS_HPUX
#elif defined(__ultrix) || defined(ultrix)
#  define PLT_OS_ULTRIX
#elif defined(sinix)
#  define PLT_OS_RELIANT
#elif defined(__native_client__)
#  define PLT_OS_NACL
#elif defined(__linux__) || defined(__linux)
#  define PLT_OS_LINUX
#elif defined(__FreeBSD__) || defined(__DragonFly__) || defined(__FreeBSD_kernel__)
#  ifndef __FreeBSD_kernel__
#    define PLT_OS_FREEBSD
#  endif
#  define PLT_OS_FREEBSD_KERNEL
#  define PLT_OS_BSD4
#elif defined(__NetBSD__)
#  define PLT_OS_NETBSD
#  define PLT_OS_BSD4
#elif defined(__OpenBSD__)
#  define PLT_OS_OPENBSD
#  define PLT_OS_BSD4
#elif defined(__bsdi__)
#  define PLT_OS_BSDI
#  define PLT_OS_BSD4
#elif defined(__sgi)
#  define PLT_OS_IRIX
#elif defined(__osf__)
#  define PLT_OS_OSF
#elif defined(_AIX)
#  define PLT_OS_AIX
#elif defined(__Lynx__)
#  define PLT_OS_LYNX
#elif defined(__GNU__)
#  define PLT_OS_HURD
#elif defined(__DGUX__)
#  define PLT_OS_DGUX
#elif defined(__QNXNTO__)
#  define PLT_OS_QNX
#elif defined(_SEQUENT_)
#  define PLT_OS_DYNIX
#elif defined(_SCO_DS) /* SCO OpenServer 5 + GCC */
#  define PLT_OS_SCO
#elif defined(__USLC__) /* all SCO platforms + UDK or OUDK */
#  define PLT_OS_UNIXWARE
#elif defined(__svr4__) && defined(i386) /* Open UNIX 8 + GCC */
#  define PLT_OS_UNIXWARE
#elif defined(__INTEGRITY)
#  define PLT_OS_INTEGRITY
#elif defined(VXWORKS) /* there is no "real" VxWorks define - this has to be set in the mkspec! */
#  define PLT_OS_VXWORKS
#elif defined(__MAKEDEPEND__)
#else
#  error "Qt has not been ported to this OS - see http://www.qt-project.org/"
#endif

#if defined(PLT_OS_WIN32) || defined(PLT_OS_WIN64) || defined(PLT_OS_WINCE) || defined(PLT_OS_WINRT)
#  define PLT_OS_WIN
#endif

#if defined(PLT_OS_DARWIN)
#  define PLT_OS_MAC
#  if defined(PLT_OS_DARWIN64)
#     define PLT_OS_MAC64
#  elif defined(PLT_OS_DARWIN32)
#     define PLT_OS_MAC32
#  endif
#  include <TargetConditionals.h>
#  if defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE
#     define PLT_OS_IOS
#  elif defined(TARGET_OS_MAC) && TARGET_OS_MAC
#     define PLT_OS_OSX
#     define PLT_OS_MACX // compatibility synonym
#  endif
#endif

#if defined(PLT_OS_WIN)
#  undef PLT_OS_UNIX
#elif !defined(PLT_OS_UNIX)
#  define PLT_OS_UNIX
#endif

#ifdef PLT_OS_DARWIN
#  include <Availability.h>
#  include <AvailabilityMacros.h>
#
#  ifdef PLT_OS_OSX
#    if !defined(__MAC_OS_X_VERSION_MIN_REQUIRED) || __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_6
#       undef __MAC_OS_X_VERSION_MIN_REQUIRED
#       define __MAC_OS_X_VERSION_MIN_REQUIRED __MAC_10_6
#    endif
#    if !defined(MAC_OS_X_VERSION_MIN_REQUIRED) || MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6
#       undef MAC_OS_X_VERSION_MIN_REQUIRED
#       define MAC_OS_X_VERSION_MIN_REQUIRED MAC_OS_X_VERSION_10_6
#    endif
#  endif
#
#  // Numerical checks are preferred to named checks, but to be safe
#  // we define the missing version names in case Qt uses them.
#
#  if !defined(__MAC_10_7)
#       define __MAC_10_7 1070
#  endif
#  if !defined(__MAC_10_8)
#       define __MAC_10_8 1080
#  endif
#  if !defined(__MAC_10_9)
#       define __MAC_10_9 1090
#  endif
#  if !defined(MAC_OS_X_VERSION_10_7)
#       define MAC_OS_X_VERSION_10_7 1070
#  endif
#  if !defined(MAC_OS_X_VERSION_10_8)
#       define MAC_OS_X_VERSION_10_8 1080
#  endif
#  if !defined(MAC_OS_X_VERSION_10_9)
#       define MAC_OS_X_VERSION_10_9 1090
#  endif
#
#  if !defined(__IPHONE_4_3)
#       define __IPHONE_4_3 40300
#  endif
#  if !defined(__IPHONE_5_0)
#       define __IPHONE_5_0 50000
#  endif
#  if !defined(__IPHONE_5_1)
#       define __IPHONE_5_1 50100
#  endif
#  if !defined(__IPHONE_6_0)
#       define __IPHONE_6_0 60000
#  endif
#  if !defined(__IPHONE_6_1)
#       define __IPHONE_6_1 60100
#  endif
#  if !defined(__IPHONE_7_0)
#       define __IPHONE_7_0 70000
#  endif
#endif

#ifdef __LSB_VERSION__
#  if __LSB_VERSION__ < 40
#    error "This version of the Linux Standard Base is unsupported"
#  endif
#ifndef QT_LINUXBASE
#  define QT_LINUXBASE
#endif
#endif

// unix线程都是用pthread库
#ifdef PLT_OS_UNIX
#	define PTHREAD
#endif

#endif

