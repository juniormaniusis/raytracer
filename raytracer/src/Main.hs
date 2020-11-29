import AlgebraLinear
import ColorMath
import Data.List
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
  let raios =
        [ Ray origin (makeDirection (fromInteger i) (fromInteger j))
          | j <- [imageHeight - 1, imageHeight - 2 .. 0], i <- [0 .. imageWidth - 1]
        ]
  --let colors = map rayColor raios
  let world = [
                Sphere (Vec3 0 0 (-1)) 0.5
              , Sphere (Vec3 0 (-100.5) (-1)) 100
              ]
  let colors =  map (rayColor world) raios
  let pixels = map ((++ "\n") . show) colors
  let concated = concat pixels
  let header = "P3\n"++ show imageWidth ++ " " ++ show imageHeight ++ "\n255\n"
  putStr (header ++ concated)


makeDirection :: Double -> Double -> Vec3
makeDirection i j = lowerLeftCorner `sumV` (u `mulV` horizontal) `sumV` (v `mulV` vertical) `subV` origin
  where
    u = i / (fromInteger imageWidth -1)
    v = j / (fromInteger imageHeight -1)

type World = [Sphere]


type Range = (Double, Double)

--hitSphere :: Sphere -> Ray -> Range -> Maybe HitRecord
closestHit :: Ray -> Range -> World -> Maybe HitRecord
closestHit ray range world = safeMinimum (map extractValue (filter  validHit hits))
  where hits = [ hitSphere s ray range  | s <- world]

extractValue :: Maybe v -> v
extractValue (Just v) = v
extractValue Nothing = error "operacao de extracao invalida"
safeMinimum :: (Traversable t, Ord a) => t a -> Maybe a
safeMinimum xs
  | null xs   = Nothing
  | otherwise = Just (minimum xs)
validHit :: Maybe HitRecord -> Bool
validHit Nothing = False
validHit (Just _) = True
--rayColor ray =
  --if t' > 0 then
    --corColisao
  --else
    --((1.0 - t) `mulC` branco) `sumC` (t `mulC` azul)

  --where
    --esferaPosition = Vec3 0 0 (-1)
    --esferaRadius = 0.5
    --normalDir = unitarioV $ getRayAt ray t  `subV` esferaPosition
    --corColisao = 0.5 `mulC` Color (getX normalDir + 1) (getY normalDir + 1) (getZ normalDir + 1)
    --t' = hitSphere esferaPosition esferaRadius ray
    --t = 0.5 * (dy + 1)
      --where
        --dy = getY $ unitarioV $ getRayDirection ray

rayColor :: World -> Ray -> Color
rayColor world ray = color
  where
   color
    | hit == Nothing  = ((1.0 - t) `mulC` branco) `sumC` (t `mulC` azul)
    | otherwise = corColisao
      where hit = closestHit ray myrange world
            myrange = (0, 999999999)
            t = 0.5 * (dy + 1)
            dy = getY $ unitarioV $ getRayDirection ray
            normalDir = unitarioV $ getNormalHit $ extractValue hit
            corColisao = 0.5 `mulC` Color (getX normalDir + 1) (getY normalDir + 1) (getZ normalDir + 1)
data Ray = Ray
  { getRayOrigin :: Vec3,
    getRayDirection :: Vec3
  }
  deriving (Show, Eq)

getRayAt :: Ray -> Double -> Vec3
getRayAt ray t = getRayOrigin ray `sumV` mulV t (getRayDirection ray)

--hitSphere :: Vec3 -> Double -> Ray -> Double
--hitSphere centro raioEsfera ray = if discriminant < 0 then -1 else smallestPoint
        --where a = getRayDirection ray ⋅ getRayDirection ray
              --b = 2 * (oc ⋅ getRayDirection ray)
              --c = (oc ⋅ oc) - raioEsfera*raioEsfera;
              --oc = getRayOrigin ray `subV` centro
              --discriminant = b*b - (4 * a * c)
              --smallestPoint = (-b - sqrt discriminant) / 2*a
data Sphere = Sphere {
                        getSphereCenter :: Vec3 -- ponto
                     ,  getSphereRadius :: Double
                     } deriving (Show, Eq)

data HitRecord = HitRecord {
                                getDist :: Double
                              , getColisionPoint :: Vec3 -- todo:: trocar por uma classe do tipo PONTO
                              , getNormalHit :: Vec3
                              , getIsFrontFace :: Bool
                           } deriving (Show, Eq)
instance Ord HitRecord where
  compare a b
    | getDist a > getDist b = GT
    | getDist a < getDist b = LT
    | otherwise             = EQ
 -- preciso de uma funcao que retorne se foi atingido e onde foi atingido
hitSphere :: Sphere -> Ray -> Range -> Maybe HitRecord
hitSphere sphere ray (minDist, maxDist)  = if not $ any (valueInInterval (minDist, maxDist))  [root1, root2]
                                          then Nothing
                                          else
                                            Just (HitRecord smallestPoint  colisionPoint (if frontFace then normal else (-1) `mulV` normal ) frontFace)
                                              where a = getRayDirection ray ⋅ getRayDirection ray
                                                    halfb = oc ⋅ getRayDirection ray
                                                    c = (oc ⋅ oc) - getSphereRadius sphere ^ 2
                                                    oc = getRayOrigin ray `subV` getSphereCenter sphere
                                                    discriminant = halfb ^ 2 - a*c
                                                    sqrtd = sqrt discriminant 
                                                    root1 = (-halfb - sqrtd) / a 
                                                    root2  = (-halfb + sqrtd) / a
                                                    colisionPoint = getRayAt ray smallestPoint
                                                    normal = (1/getSphereRadius sphere) `mulV` (colisionPoint `subV` getSphereCenter sphere)
                                                    smallestPoint = smallestInInterval [root1,root2] (minDist, maxDist)
                                                    frontFace = unitarioV (getRayDirection ray) `dotV` unitarioV normal < 0
valueInInterval :: (Double, Double) -> Double -> Bool
valueInInterval (min, max) v
 | min < v && v < max = True
 | otherwise            = False

smallestInInterval :: [Double] -> (Double, Double) -> Double
smallestInInterval numbers interval = minimum  pontosNoIntervalo
  where
    pontosNoIntervalo = filter (valueInInterval interval) numbers
