module ColorMath where
import Utils




cPreto, cAzulCeu, cBranco     :: Color 
cBranco   = Color 1 1 1
cPreto    = Color 0 0 0
cAzulCeu  = Color 0.5 0.7 1.0

sumC :: Color -> Color -> Color
(Color x1 y1 z1) `sumC` (Color x2 y2 z2) = Color (x1 + x2) (y1 + y2) (z1 + z2)
mulC :: Double -> Color -> Color
mulC num (Color x2 y2 z2) = Color (num * x2) (num * y2) (num * z2)



data Color = Color
  { getR :: Double,
    getG :: Double,
    getB :: Double
  }
  deriving (Eq, Read)

instance Show Color where
  show color = show (floor red') ++ " " ++ show (floor green') ++ " " ++ show  (floor blue')
    where red = getR color * scale
          green = getG color * scale
          blue = getB color * scale
          scale = 1.0 / fromIntegral samplePerPixel
          red' = 256 * clamp red  0.0 0.999
          green' = 256 * clamp green 0.0 0.999
          blue' = 256 * clamp blue  0.0 0.999

clamp :: Ord a => a -> a -> a -> a
clamp v min max
  | v < min   = min
  | v > max   = max
  | otherwise = v
