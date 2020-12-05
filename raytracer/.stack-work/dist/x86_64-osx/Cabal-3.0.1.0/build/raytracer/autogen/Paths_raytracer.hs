{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_raytracer (
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

bindir     = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/c081627949d8eb1d7f1d321414a64944fe1cdefa5ff4260c8ab4d272e57a0d4a/8.8.4/bin"
libdir     = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/c081627949d8eb1d7f1d321414a64944fe1cdefa5ff4260c8ab4d272e57a0d4a/8.8.4/lib/x86_64-osx-ghc-8.8.4/raytracer-0.1.0.0-AP2SBAJx6lc9xoNUfZ00na-raytracer"
dynlibdir  = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/c081627949d8eb1d7f1d321414a64944fe1cdefa5ff4260c8ab4d272e57a0d4a/8.8.4/lib/x86_64-osx-ghc-8.8.4"
datadir    = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/c081627949d8eb1d7f1d321414a64944fe1cdefa5ff4260c8ab4d272e57a0d4a/8.8.4/share/x86_64-osx-ghc-8.8.4/raytracer-0.1.0.0"
libexecdir = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/c081627949d8eb1d7f1d321414a64944fe1cdefa5ff4260c8ab4d272e57a0d4a/8.8.4/libexec/x86_64-osx-ghc-8.8.4/raytracer-0.1.0.0"
sysconfdir = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/c081627949d8eb1d7f1d321414a64944fe1cdefa5ff4260c8ab4d272e57a0d4a/8.8.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "raytracer_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "raytracer_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "raytracer_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "raytracer_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "raytracer_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "raytracer_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
