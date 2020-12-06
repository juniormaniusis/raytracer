import AlgebraLinear
import ColorMath
import Data.List (sort)
import System.Random
import Control.Monad.State
import Utils
import Data.Maybe
import Control.Parallel.Strategies
import Control.Exception
import Data.Time.Clock
import Control.DeepSeq
import Data.Foldable
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

type Coordinate = (Integer, Integer)
makeRayBundle :: Vec3 -> Coordinate -> RayBundle
makeRayBundle origem (x, y) = [Ray origem (makeDirection (fromInteger x + d) (fromInteger y + d)) | d <- take samplePerPixel (randoms (mkStdGen (fromInteger x + fromInteger y)) :: [Double])]


brancoM :: Aleatorio Color 
brancoM = return cBranco

main :: IO ()
main = do
  t0 <- getCurrentTime
  print t0
  g <- getStdGen
  let header = "P3\n"++ show imageWidth ++ " " ++ show imageHeight ++ "\n255\n"
  let s = evalState pixels g
  print $ length s
  let fp = "image" ++  show t0 ++ ".ppm"
  writeFile fp (header ++ concat s)
  t1 <- getCurrentTime
  print (diffUTCTime t1 t0)
    where
      raios = [ makeRayBundle origin (i, j) | j <- [imageHeight - 1, imageHeight - 2 .. 0], i <- [0 .. imageWidth - 1] ]
      pixels = fmap (map ((++ "\n") . show)) (evaluateRayBundle raios world)
      world = [
                
                Sphere (Vec3 (-1)     (-0.05)   (-1))     0.1,
                Sphere (Vec3 (-0.75)  0         (-1.75))  0.2,
                Sphere (Vec3 (-0)     0         (-1.5))   0.2,
                Sphere (Vec3  0.75    0         (-1.75))  0.1,
                Sphere (Vec3  1       0         (-1.5))   0.3,
                Sphere (Vec3  0       (-100.25) (-1))     100
              ]


evaluateRayBundle :: [RayBundle] -> World -> Aleatorio [Color]
evaluateRayBundle rs w = mapM (rayBundleColor w) rs

makeDirection :: Double -> Double -> Vec3
makeDirection i j = lowerLeftCorner `sumV` (u `mulV` horizontal) `sumV` (v `mulV` vertical) `subV` origin
  where
    u = i / (fromInteger imageWidth -1)
    v = j / (fromInteger imageHeight -1)

type World = [Sphere]
type Range = (Double, Double)

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

rayBundleColor :: World -> RayBundle ->   Aleatorio Color
rayBundleColor w rb  =    foldl' sumCM brancoM colors
                          where colors = map (rayColor w) rb
sumCM :: Aleatorio Color -> Aleatorio Color -> Aleatorio Color
sumCM a b = do
              a' <- a
              sumC a' <$> b

rayColor :: World -> Ray -> Aleatorio Color
rayColor w r = rayColor' w r depth

rayColor' :: World -> Ray -> Int -> Aleatorio Color
rayColor' _ _ 0 = return cPreto
rayColor' world ray depth =
  do
    randomRay <- randomUnitVec3
    if rayHits then
            fmap (mulC 0.5)  (force rayColor' world (Ray (getColisionPoint $ extractValue hit) (sumV semiTarget randomRay `subV` getColisionPoint (extractValue hit))) (depth-1))
    else return defaultColor
      where rayHits = isJust hit
            defaultColor = ((1.0 - t) `mulC` cBranco) `sumC` (t `mulC` cAzulCeu)
            hit = closestHit ray myrange world
            myrange = (0, 999999999)
            t = 0.5 * (dy + 1)
            dy = getY $ unitarioV $ getRayDirection ray
            semiTarget =  sumV (getColisionPoint $ extractValue hit) (getNormalHit $ extractValue hit)
data Ray = Ray
  { getRayOrigin :: Vec3,
    getRayDirection :: Vec3
  }
  deriving (Show, Eq)
type RayBundle = [Ray]

getRayAt :: Ray -> Double -> Vec3
getRayAt ray t = getRayOrigin ray `sumV` mulV t (getRayDirection ray)

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
                                                    frontFace = getRayDirection ray `dotV` normal < 0
valueInInterval :: (Double, Double) -> Double -> Bool
valueInInterval (min, max) v
 | min < v && v < max = True
 | otherwise            = False

smallestInInterval :: [Double] -> (Double, Double) -> Double
smallestInInterval numbers interval = minimum  pontosNoIntervalo
  where
    pontosNoIntervalo = filter (valueInInterval interval) numbers

type Aleatorio a = State StdGen a
randomDouble :: Aleatorio Double
randomDouble = state random

randomVec3 :: Aleatorio Vec3
randomVec3 = do
                x <- randomDouble
                y <- randomDouble
                Vec3 x y <$> randomDouble
randomUnitVec3 :: Aleatorio Vec3
randomUnitVec3 = do
                  v <- randomVec3
                  if v `dotV` v <= 1 then pure v else randomUnitVec3

