cmake_minimum_required(VERSION 3.4.1)
project("SoftEther VPN"
  VERSION 5.01.9670
  LANGUAGES C
)

include(tools.cmake)
include(openssl.cmake)
include(ncurses.cmake)
include(readline.cmake)
include(iconv.cmake)

set(TOP_DIRECTORY SoftEtherVPN)

# Compare ${PROJECT_VERSION} and src/CurrentBuild.txt
file(READ ${TOP_DIRECTORY}/src/CurrentBuild.txt CurrentBuild)

string(REGEX MATCH "VERSION_MAJOR ([0-9]+)" temp ${CurrentBuild})
string(REGEX REPLACE "VERSION_MAJOR ([0-9]+)" "\\1" CurrentBuild_MAJOR ${temp})
string(REGEX MATCH "VERSION_MINOR ([0-9]+)" temp ${CurrentBuild})
string(REGEX REPLACE "VERSION_MINOR ([0-9]+)" "\\1" CurrentBuild_MINOR ${temp})
string(REGEX MATCH "VERSION_BUILD ([0-9]+)" temp ${CurrentBuild})
string(REGEX REPLACE "VERSION_BUILD ([0-9]+)" "\\1" CurrentBuild_BUILD ${temp})

# Date and time
string(TIMESTAMP DATE_DAY "%d" UTC)
string(TIMESTAMP DATE_MONTH "%m" UTC)
string(TIMESTAMP DATE_YEAR "%Y" UTC)
string(TIMESTAMP TIME_HOUR "%H" UTC)
string(TIMESTAMP TIME_MINUTE "%M" UTC)
string(TIMESTAMP TIME_SECOND "%S" UTC)

message(STATUS "Build date: ${DATE_DAY}/${DATE_MONTH}/${DATE_YEAR}")
message(STATUS "Build time: ${TIME_HOUR}:${TIME_MINUTE}:${TIME_SECOND}")

include_directories(
	SoftEtherVPN/src/
	include/
	)

## building cedar
set(cedar_srcs
	Account.c
	Admin.c
	AzureClient.c
	AzureServer.c
	Bridge.c
	BridgeUnix.c
	CM.c
	Cedar.c
	CedarPch.c
	Client.c
	Command.c
	Connection.c
	Console.c
	DDNS.c
	Database.c
	EM.c
	EtherLog.c
	Hub.c
	IPC.c
	Layer3.c
	Link.c
	Listener.c
	Logging.c
	NM.c
	Nat.c
	NativeStack.c
	NullLan.c
	Proto_EtherIP.c
	Proto_IKE.c
	Proto_IPsec.c
	Proto_IkePacket.c
	Proto_L2TP.c
	Proto_OpenVPN.c
	Proto_PPP.c
	Proto_SSTP.c
	Protocol.c
	Radius.c
	Remote.c
	SM.c
	SW.c
	Sam.c
	SeLowUser.c
	SecureInfo.c
	SecureNAT.c
	Server.c
	Session.c
	UT.c
	UdpAccel.c
	VG.c
	VLan.c
	VLanUnix.c
	Virtual.c
	WaterMark.c
	WebUI.c
	WinUi.c
	Wpc.c)

PREPEND(cedar_srcs_with_path "SoftEtherVPN/src/Cedar" ${cedar_srcs}) 

add_library(cedar ${cedar_srcs_with_path})
target_compile_definitions(cedar PRIVATE -DCEDAR_VERSION_MAJOR=${PROJECT_VERSION_MAJOR} -DCEDAR_VERSION_MINOR=${PROJECT_VERSION_MINOR} -DCEDAR_VERSION_BUILD=${PROJECT_VERSION_PATCH} -DBUILDER_NAME="$ENV{USER}" -DUNIX_LINUX -DUNIX)
target_compile_options(cedar PRIVATE -fPIE -fsigned-char -O2)
target_link_libraries(cedar PRIVATE readline ncurses)

## building mayaqua
set(mayaqua_srcs
	Cfg.c
	Encrypt.c
	FileIO.c
	Internat.c
	Kernel.c
	Mayaqua.c
	Memory.c
	Network.c
	OS.c
	Object.c
	Pack.c
	Secure.c
	Str.c
	Table.c
	TcpIp.c
	Tick64.c
	Tracking.c
	Unix.c)

PREPEND(mayaqua_srcs_with_path "SoftEtherVPN/src/Mayaqua" ${mayaqua_srcs})
add_library(mayaqua ${mayaqua_srcs_with_path})

target_link_libraries(mayaqua PRIVATE ssl crypto z iconv)
target_compile_definitions(mayaqua PRIVATE
	-DSKIP_CPU_FEATURES -DUNIX_LINUX -DUNIX)
target_compile_options(cedar PRIVATE -fPIE -fsigned-char -O2)

# build hamcorebuilder
add_executable(hamcorebuilder SoftEtherVPN/src/hamcorebuilder/hamcorebuilder.c)
target_compile_options(hamcorebuilder PRIVATE -fPIE -fsigned-char -O2)
target_link_libraries(hamcorebuilder cedar mayaqua)


# build vpnclient
add_executable(vpnclient SoftEtherVPN/src/vpnclient/vpncsvc.c)
target_compile_options(vpnclient PRIVATE -fPIE -fsigned-char -O2)
target_link_libraries(vpnclient cedar mayaqua)


# build vpncmd
add_executable(vpncmd SoftEtherVPN/src/vpncmd/vpncmd.c)
target_compile_options(vpncmd PRIVATE -fPIE -fsigned-char -O2)
target_link_libraries(vpncmd cedar mayaqua)

# post build
set(SOFTETHER_ASSET_DIR ${CMAKE_SOURCE_DIR}/../../../build/sevpnassets/${ANDROID_ABI})

add_custom_target(makeassetdir ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory ${SOFTETHER_ASSET_DIR})

add_custom_command(TARGET hamcorebuilder POST_BUILD
  COMMAND
  ${CMAKE_COMMAND} -E copy
  ${CMAKE_CURRENT_BINARY_DIR}/hamcorebuilder
  ${SOFTETHER_ASSET_DIR}
)

add_custom_command(TARGET vpncmd POST_BUILD
  COMMAND
  ${CMAKE_COMMAND} -E copy
  ${CMAKE_CURRENT_BINARY_DIR}/vpncmd
  ${SOFTETHER_ASSET_DIR}
)

add_custom_command(TARGET vpnclient POST_BUILD
  COMMAND
  ${CMAKE_COMMAND} -E copy
  ${CMAKE_CURRENT_BINARY_DIR}/vpnclient
  ${SOFTETHER_ASSET_DIR}
)

add_dependencies(hamcorebuilder makeassetdir)
add_dependencies(vpncmd makeassetdir)
add_dependencies(vpnclient makeassetdir)