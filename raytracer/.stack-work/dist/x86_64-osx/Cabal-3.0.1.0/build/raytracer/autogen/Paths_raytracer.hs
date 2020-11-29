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

bindir     = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/7d82c7c9054d7828709f9c6a894d8474c5d390c07b0769d98cdc578627735776/8.8.4/bin"
libdir     = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/7d82c7c9054d7828709f9c6a894d8474c5d390c07b0769d98cdc578627735776/8.8.4/lib/x86_64-osx-ghc-8.8.4/raytracer-0.1.0.0-7AVvOC7sDRL79wuq35LMQa-raytracer"
dynlibdir  = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/7d82c7c9054d7828709f9c6a894d8474c5d390c07b0769d98cdc578627735776/8.8.4/lib/x86_64-osx-ghc-8.8.4"
datadir    = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/7d82c7c9054d7828709f9c6a894d8474c5d390c07b0769d98cdc578627735776/8.8.4/share/x86_64-osx-ghc-8.8.4/raytracer-0.1.0.0"
libexecdir = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/7d82c7c9054d7828709f9c6a894d8474c5d390c07b0769d98cdc578627735776/8.8.4/libexec/x86_64-osx-ghc-8.8.4/raytracer-0.1.0.0"
sysconfdir = "/Users/carlosmaniusis/repos/2020-qs-paradigmas-diurno-projetofinal-juniormaniusis/raytracer/.stack-work/install/x86_64-osx/7d82c7c9054d7828709f9c6a894d8474c5d390c07b0769d98cdc578627735776/8.8.4/etc"

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
