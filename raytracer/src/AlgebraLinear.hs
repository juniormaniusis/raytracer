
module AlgebraLinear where
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



mulV :: Double -> Vec3 -> Vec3
mulV num (Vec3 x2 y2 z2) = Vec3 (num * x2) (num * y2) (num * z2)

normaV :: Vec3 -> Double
normaV (Vec3 x y z) = sqrt $ (x * x) + (y * y) + (z * z)

unitarioV :: Vec3 -> Vec3
unitarioV v = (1 / normaV v) `mulV` v

(⋅) :: Vec3 -> Vec3 -> Double
(⋅) = dotV


