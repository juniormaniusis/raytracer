module ColorMath where 

branco :: Color
branco = Color 1 1 1

azul :: Color
azul = Color 0.5 0.7 1.0

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
  show c = show (floor (getR c * 255.99)) ++ " " ++ show (floor (getG c * 255.99)) ++ " " ++ show (floor (getB c * 255.99))

