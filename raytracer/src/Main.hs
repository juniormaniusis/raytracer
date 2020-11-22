module Main where

-- constantes
--cores
branco :: Color
branco = Color 1 1 1

azul :: Color
azul = Color 0.5 0.7 1.0

-- configurações da imagem
-- image
aspectRatio :: Double
aspectRatio = 16.0 / 9.0

imageWidth :: Integer
imageWidth = 400

imageHeight :: Integer
imageHeight = round $ fromInteger imageWidth / aspectRatio

-- camera
viewPortHeight :: Double
viewPortHeight = 2.0

viewPortWidth :: Double
viewPortWidth =  viewPortHeight * aspectRatio

focalLength :: Double
focalLength = 1.0

origin :: Vec3
origin = Vec3 0 0 0

horizontal :: Vec3
horizontal = Vec3 viewPortWidth 0 0

vertical :: Vec3
vertical = Vec3 0 viewPortHeight 0

lowerLeftCorner :: Vec3
lowerLeftCorner = origin `subV` (0.5 `mulV` horizontal) `subV` (0.5 `mulV` vertical) `subV` Vec3 0 0 focalLength

main :: IO ()
main = do
  -- let pixels = [show (Color r g 63) ++ "\n" | r <- [1 .. imageWidth], g <- [1 .. imageHeight]]
  let raios =
        [ Ray origin (makeDirection (fromInteger i) (fromInteger j))
          | j <- [imageHeight - 1, imageHeight - 2 .. 0], i <- [0 .. imageWidth - 1]
        ]
  let colors = map rayColor raios
  let pixels = map ((++ "\n") . show) colors
  let concated = concat pixels
  let header = "P3\n"++ show imageWidth ++ " " ++ show imageHeight ++ "\n255\n"
  putStr (header ++ concated)


makeDirection :: Double -> Double -> Vec3
makeDirection i j = lowerLeftCorner `sumV` (u `mulV` horizontal) `sumV` (v `mulV` vertical) `subV` origin
  where
    u = i / (fromInteger imageWidth -1)
    v = j / (fromInteger imageHeight -1)


rayColor :: Ray -> Color
rayColor ray = 
  if hitSphere (Vec3 0 0 (-1)) 0.5 ray then 
      Color 1 0 0
    else
    ((1.0 - t) `mulC` branco) `sumC` (t `mulC` azul)

  where
    t = 0.5 * (dy + 1)
      where
        dy = getY $ unitarioV $ getRayDirection ray
        
--   color ray_color(const ray& r) {print $ take 100 raios
--     vec3 unit_direction = unit_vector(r.direction());
--     auto t = 0.5*(unit_direction.y() + 1.0);
--     return (1.0-t)*color(1.0, 1.0, 1.0) + t*color(0.5, 0.7, 1.0);
-- }

data Vec3 = Vec3
  { getX :: Double,
    getY :: Double,
    getZ :: Double
  }
  deriving (Show, Eq)

sumV :: Vec3 -> Vec3 -> Vec3
(Vec3 x1 y1 z1) `sumV` (Vec3 x2 y2 z2) = Vec3 (x1 + x2) (y1 + y2) (z1 + z2)

dotV :: Vec3 -> Vec3 -> Double
Vec3 x1 y1 z1  `dotV` Vec3 x2 y2 z2  = x1*x2 + y1*y2 + z1*z2

subV :: Vec3 -> Vec3 -> Vec3
v1 `subV` v2 = v1 `sumV` ((-1) `mulV` v2)

sumC :: Color -> Color -> Color
(Color x1 y1 z1) `sumC` (Color x2 y2 z2) = Color (x1 + x2) (y1 + y2) (z1 + z2)

mulV :: Double -> Vec3 -> Vec3
mulV num (Vec3 x2 y2 z2) = Vec3 (num * x2) (num * y2) (num * z2)

mulC :: Double -> Color -> Color
mulC num (Color x2 y2 z2) = Color (num * x2) (num * y2) (num * z2)

normaV :: Vec3 -> Double
normaV (Vec3 x y z) = sqrt ((x * x) + (y * y) + (z * z))

unitarioV :: Vec3 -> Vec3
unitarioV v = (1 / normaV v) `mulV` v

data Color = Color
  { getR :: Double,
    getG :: Double,
    getB :: Double
  }
  deriving (Eq, Read)

instance Show Color where
  show c = show (round (getR c * 255.99)) ++ " " ++ show (round (getG c * 255.99)) ++ " " ++ show (round (getB c * 255.99))

data Ray = Ray
  { getRayOrigin :: Vec3,
    getRayDirection :: Vec3
  }
  deriving (Show, Eq)

getRayAt :: Ray -> Double -> Vec3
getRayAt ray t = getRayOrigin ray `sumV` mulV t (getRayDirection ray)

hitSphere :: Vec3 -> Double -> Ray -> Bool
hitSphere centro raioEsfera ray = discriminant > 0
        where a = getRayDirection ray `dotV` getRayDirection ray
              b = 2 * (oc `dotV` getRayDirection ray)
              c = (oc `dotV` oc) - raioEsfera*raioEsfera;
              oc = getRayOrigin ray `subV` centro
              discriminant = b*b - (4 * a * c)

