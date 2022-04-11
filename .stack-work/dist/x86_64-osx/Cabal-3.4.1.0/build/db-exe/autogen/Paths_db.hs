{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_db (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/a.v.protasov/Desktop/db/db/.stack-work/install/x86_64-osx/e749d609ac264e4301827d0fc53d744e25f85e5bff8b0490a58e8140a44e0331/9.0.2/bin"
libdir     = "/Users/a.v.protasov/Desktop/db/db/.stack-work/install/x86_64-osx/e749d609ac264e4301827d0fc53d744e25f85e5bff8b0490a58e8140a44e0331/9.0.2/lib/x86_64-osx-ghc-9.0.2/db-0.1.0.0-4ZDfU9DBoHL3Xujc7ljBYl-db-exe"
dynlibdir  = "/Users/a.v.protasov/Desktop/db/db/.stack-work/install/x86_64-osx/e749d609ac264e4301827d0fc53d744e25f85e5bff8b0490a58e8140a44e0331/9.0.2/lib/x86_64-osx-ghc-9.0.2"
datadir    = "/Users/a.v.protasov/Desktop/db/db/.stack-work/install/x86_64-osx/e749d609ac264e4301827d0fc53d744e25f85e5bff8b0490a58e8140a44e0331/9.0.2/share/x86_64-osx-ghc-9.0.2/db-0.1.0.0"
libexecdir = "/Users/a.v.protasov/Desktop/db/db/.stack-work/install/x86_64-osx/e749d609ac264e4301827d0fc53d744e25f85e5bff8b0490a58e8140a44e0331/9.0.2/libexec/x86_64-osx-ghc-9.0.2/db-0.1.0.0"
sysconfdir = "/Users/a.v.protasov/Desktop/db/db/.stack-work/install/x86_64-osx/e749d609ac264e4301827d0fc53d744e25f85e5bff8b0490a58e8140a44e0331/9.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "db_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "db_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "db_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "db_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "db_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "db_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
