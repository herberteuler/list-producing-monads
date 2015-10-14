{-# LANGUAGE MagicHash, UnboxedTuples, GHCForeignImportPrim, UnliftedFFITypes, BangPatterns #-}
-- | This module allows for the (obviously unsafe) overwriting of one haskell value with another.
module Holes where

import GHC.IO
import GHC.Prim
import GHC.Exts

foreign import prim "newHolezh" newHole# :: Int# -> (# Any #)
foreign import prim "setHolezh" setHole# :: Any -> Any -> (##)

-- | Allocate a value that can be overwritten *once* with @setHole@.
newHole :: IO a
newHole = case newHole# 0# of
  (# x #) -> return (unsafeCoerce# x)
{-# INLINEABLE newHole #-}

-- Set the value of something allocated with @newHole@
setHole :: a -> a -> IO ()
setHole x y = case setHole# (unsafeCoerce# x :: Any) (unsafeCoerce# y :: Any) of
  (##) -> return ()
{-# INLINEABLE setHole #-}
