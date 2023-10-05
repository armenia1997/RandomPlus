-- Created by @armenia1997 (Erik Lavoie) 
-- Special credits to @MYOriginsWorkshop, see below
--Last Edit: September 26, 2023

local module = {}
local cofactor, determinant

local function createMatrix(numberOfRows, numberOfColumns, allNumberValues)
	allNumberValues = allNumberValues or 0
	local result = {}
	for row = 1, numberOfRows, 1 do
		result[row] = {}
		for column = 1, numberOfColumns, 1 do
			result[row][column] = allNumberValues
		end	
	end
	return result
end

function module.matMult(A, B)
	local C = createMatrix(#A, #B[1])
	for i = 1, #A do
		for j = 1, #B[1] do
			C[i][j] = 0
			for k = 1, #A[1] do
				C[i][j] = C[i][j] + A[i][k] * B[k][j]
			end
		end
	end
	return C
end

function module.scalarMatMult(scalar, matrix)
	local rows = #matrix
	local cols = #matrix[1]
	local result = createMatrix(rows, cols)

	for i = 1, rows do
		for j = 1, cols do
			result[i][j] = scalar * matrix[i][j]
		end
	end

	return result
end

function module.matSubtract(A, B)
	local C = createMatrix(#A, 1)
	for i = 1, #A do
		C[i][1] = A[i][1] - B[i][1]
	end
	return C
end

-- Special credits to @MYOriginsWorkshop for the following five functions below:

local function matMinor(matrix, row, column)
	local size = #matrix
	local minor = {}
	local coroutines = {}
	for i = 1, size - 1 do
		minor[i] = {}
		for j = 1, size - 1 do
			local mRow = i < row and i or i + 1
			local mCol = j < column and j or j + 1
			minor[i][j] = matrix[mRow][mCol]
		end
	end
	return minor
end

matCofactor = function(matrix, row, column)
	local minor = matMinor(matrix, row, column)
	local sign = ((row + column) % 2 == 0) and 1 or -1
	return sign * matDeterminant(minor)
end

matDeterminant = function(matrix)
	local size = #matrix
	if size == 1 then
		return matrix[1][1]
	elseif size == 2 then
		return matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1]
	else
		local det = 0
		for i = 1, size do
			local cofactor =  matCofactor(matrix, 1, i)
			det = det + matrix[1][i] * cofactor
		end
		return det
	end
end

function module.matTranspose(matrix)
	local currentRowVector
	local numberOfRows = #matrix
	local numberOfColumns = #matrix[1]
	local result = createMatrix(numberOfColumns, numberOfRows)
	for row = 1, numberOfRows, 1 do
		currentRowVector = matrix[row]
		for column = 1, #currentRowVector, 1 do
			result[column][row] = currentRowVector[column]
		end
	end
	return result
end

function module.matInverse(matrix)
	if (#matrix ~= #matrix[1]) then return nil end
	local size = #matrix
	local det = matDeterminant(matrix)
	if det == 0 then
		return nil
	else
		local adjugate = {}
		for i = 1, size do
			adjugate[i] = {}
			for j = 1, size do
				local cof = matCofactor(matrix, i, j)
				adjugate[i][j] = cof
			end
		end
		local inverse = module.matTranspose(adjugate)
		for i = 1, size do
			for j = 1, size do
				inverse[i][j] = inverse[i][j] / det
			end
		end
		return inverse
	end
end

local function conclusionStatement(pValue, alpha)
	local rejectH0 
	if pValue <= alpha then
		rejectH0 = true
	else
		rejectH0 = false
	end
	return rejectH0
end

local function boxMuller()
	-- box-muller method for normal distribution
	local u1 = math.random()
	local u2 = math.random()
	local r = math.sqrt(-2 * math.log(u1))
	local theta = 2 * math.pi * u2
	return r * math.cos(theta)
end

local function GenerateGamma(alpha, beta)
	if alpha <= 0 or beta <= 0 then
		warn("ERROR: ALPHA AND/OR BETA CANNOT BE A VALUE BELOW ZERO")
	end
	-- marsaglia and tsang method for gamma distribution
	if alpha < 1 then
		local u = math.random()
		return GenerateGamma(alpha + 1, beta) * u ^ (1 / alpha)
	end
	local d = alpha - 1 / 3
	local c = 1 / math.sqrt(9 * d)
	local x, v
	while true do
		x = boxMuller()
		v = 1 + c * x
		if v > 0 then
			break
		end
	end
	v = v ^ 3
	local u = math.random()
	if math.log(u) < 0.5 * x ^ 2 + d - (d * v) + d * math.log(v) then
		return d * v / beta
	else
		return GenerateGamma(alpha, beta)
	end
end

local function createSamplesBeta(alpha, beta, LQpercent, UQpercent)
	local samples = {}
	local numSamples = 25000
	for i = 1, numSamples do
		local x = GenerateGamma(alpha, 1)
		local y = GenerateGamma(beta, 1)
		samples[i] = x / (x + y)
	end
	table.sort(samples)
	local lowerQuantile = samples[math.floor(numSamples * LQpercent)]
	local upperQuantile = samples[math.floor(numSamples * UQpercent)]
	return lowerQuantile, upperQuantile
end

local function scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	print(x, lowerQuantile, upperQuantile)
	local normalized = (x - lowerQuantile) / (upperQuantile - lowerQuantile)
	return normalized * (desiredMax - desiredMin) + desiredMin
end

local function scaleToDesiredRangeNorm(x, desiredMin, desiredMax)
	local normalized = (x + 3.09) / (7.18)
	return normalized * (desiredMax - desiredMin) + desiredMin
end

local function evaluateUserFunction(userFunctionString, xValue)
	local funcStr = "return " .. userFunctionString
	local func = loadstring(funcStr)
	if func then
		setfenv(func, { x = xValue, math = math })
		return func()
	else
		return warn("ERROR: CANNOT READ FUNCTION")
	end
end

local function findAbsoluteMaximum(piecewiseFunctions)
	local maxValue = -math.huge
	for _, funcData in pairs(piecewiseFunctions) do
		local userFunctionString, xMin, xMax = unpack(funcData)
		maxValue = math.max(maxValue, evaluateUserFunction(userFunctionString, xMin))
		local step = (xMax - xMin) ^ 1.5 / 500
		for x = xMin + step, xMax - step, step do
			local value = evaluateUserFunction(userFunctionString, x)
			maxValue = math.max(maxValue, value)
		end
		maxValue = math.max(maxValue, evaluateUserFunction(userFunctionString, xMax))
	end
	return maxValue
end

local function getRandomCoordinate(xMin, xMax, maxValue)
	local randomX = math.random() * (xMax - xMin) + xMin
	local randomY = math.random() * maxValue
	return randomX, randomY
end

local function chooseNextState(currentState, transitionMatrix)
	local r = math.random()
	local cumulativeProb = 0
	for nextState, prob in pairs(transitionMatrix[currentState]) do 
		cumulativeProb = cumulativeProb + prob
		if r <= cumulativeProb then
			return nextState 
		end
	end
end

local function GenerateNormal(mu, sigma)
	return mu + sigma * boxMuller()
end

local function kernelDensityEstimation(values, bandwidth, x, n, kernelType)
	local sum = 0
	for i = 1, n do
		local u = (x - values[i]) / bandwidth
		if kernelType == "gaussian" or kernelType == "Gaussian" or kernelType == "normal" or kernelType == "Normal" or kernelType == nil then
			sum = sum + (1 / math.sqrt(2 * math.pi)) * math.exp(-0.5 * u ^ 2)
		elseif kernelType == "epanechnikov" or kernelType == "Epanechnikov" then
			if math.abs(u) <= 1 then
				sum = sum + (0.75 * (1 - u ^ 2))
			end
		elseif kernelType == "uniform" or kernelType == "Uniform" then
			if math.abs(u) <= 1 then
				sum = sum + 0.5
			end	
		elseif kernelType == "triangular" or kernelType == "Triangular" then
			if math.abs(u) <= 1 then
				sum = sum + (1 - math.abs(u))
			end
		elseif kernelType == "biweight" or kernelType == "Biweight" then
			if math.abs(u) <= 1 then
				sum =  sum + ((15 / 16) * (1 - u ^ 2) ^ 2)
			end
		elseif kernelType == "cosine" or kernelType == "Cosine" then
			if math.abs(u) <= 1 then
				sum = sum + ((math.pi / 4) * math.cos(math.pi * u / 2) * (1 - u ^ 2) ^ 2)
			end
		elseif kernelType == "logistic" or kernelType == "Logistic" then
			sum = sum + (1 / (2 + math.exp(u) + math.exp(-u)))
		elseif kernelType == "sigmoid" or kernelType == "Sigmoid" then
			sum = sum + ((2 / math.pi) * (1 / (math.exp(u) + math.exp(-u))))
		else
			error("Invalid Kernel Type")
		end
	end
	return sum / (n * bandwidth)
end

local function StandardDeviation(values)
	if #values == 1 then 
		return 0
	end
	local sum = 0
	local mean = 0
	for i = 1, #values do
		mean = mean + values[i]
	end
	mean = mean / #values

	for i = 1, #values do
		sum = sum + (values[i] - mean) ^ 2
	end

	return math.sqrt(sum / (#values - 1))
end

local function Mean(values)
	local sum = 0
	for _, value in ipairs(values) do
		sum = sum + value
	end
	return sum / #values
end

local function Median(values)
	local copyValues = {}
	for i, v in ipairs(values) do
		copyValues[i] = v
	end
	table.sort(copyValues)
	local n = #copyValues
	if n % 2 == 1 then
		return copyValues[math.ceil(n / 2)]
	else
		local middle1 = math.floor(n / 2)
		local middle2 = middle1 + 1
		if copyValues[middle1] and copyValues[middle2] then
			return (copyValues[middle1] + copyValues[middle2]) / 2
		else
			return nil 
		end
	end
end

local function Mode(values)
	local counts = {}
	local maxCount = 0
	local modes = {}
	for _, value in ipairs(values) do
		counts[value] = (counts[value] or 0) + 1
		if counts[value] > maxCount then
			maxCount = counts[value]
		end
	end
	for value, count in pairs(counts) do
		if count == maxCount then
			table.insert(modes, value)
		end
	end
	return modes
end

local function Range(values)
	local maxValue = math.max(unpack(values))
	local minValue = math.min(unpack(values))
	return maxValue - minValue
end

local function Factorial(n)
	if n == 0 then
		return 1
	else
		return n * Factorial(n - 1)
	end
end

local function logFactorial(n)
	if n == 0 then return 0 end
	local sum = 0
	for i = 1, n do
		sum = sum + math.log(i)
	end
	return sum
end

local function ErrorFunction(x)
	local sum = 0
	for n = 0, 100, 1 do
		local term = ((-1) ^ n * x ^ (2 * n + 1)) / (Factorial(n) * (2 * n + 1))
		sum = sum + term
	end
	return (2 / math.sqrt(math.pi)) * sum
end

local function preliminaryInverseErrorFunction(x)
	local a1 =  0.254829592
	local a2 = -0.284496736
	local a3 =  1.421413741
	local a4 = -1.453152027
	local a5 =  1.061405429
	local p  =  0.3275911
	local sign = 1
	if x < 0 then
		sign = -1
	end
	x = math.abs(x)
	local t = 1.0 / (1.0 + p * x)
	local y = (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t
	return sign * y * math.sqrt(-2 * math.log(1 - x))
end

local function InverseErrorFunction(x) -- newton-raphson
	local guess = preliminaryInverseErrorFunction(x)
	for i = 1, 1000 do
		local a = (ErrorFunction(guess) - x) / (2 / math.sqrt(math.pi) * math.exp(-guess * guess))
		guess = guess - a
		if math.abs(a) < 1e-10 then
			break
		end
	end
	return guess
end

local function InverseComplementaryErrorFunction(x)
	return -InverseErrorFunction(1 - x)
end

local function InterquartileRange(values)
	if #values < 2 then
		error("List must contain <= 2 values")
	end
	local copyValues = {}
	for i, v in ipairs(values) do
		copyValues[i] = v
	end
	table.sort(copyValues)
	local n = #copyValues
	local Q1, Q3

	if n == 2 then
		return copyValues[2] - copyValues[1]
	end

	local Q1Index = 0.25 * (n + 1)
	local Q3Index = 0.75 * (n + 1)

	if copyValues[math.floor(Q1Index)] and copyValues[math.ceil(Q1Index)] then
		if Q1Index == math.floor(Q1Index) then
			Q1 = copyValues[Q1Index]
		else
			Q1 = copyValues[math.floor(Q1Index)] * (1 - (Q1Index % 1)) + copyValues[math.ceil(Q1Index)] * (Q1Index % 1)
		end
	end

	if copyValues[math.floor(Q3Index)] and copyValues[math.ceil(Q3Index)] then
		if Q3Index == math.floor(Q3Index) then
			Q3 = copyValues[Q3Index]
		else
			Q3 = copyValues[math.floor(Q3Index)] * (1 - (Q3Index % 1)) + copyValues[math.ceil(Q3Index)] * (Q3Index % 1)
		end
	end
	if Q1 and Q3 then
		return Q3 - Q1
	else
		error("Error")
	end
end

local function lowerIncompleteGamma(s, x)
	local sum = 0
	local term = 1 / s
	for n = 1, 1000000 do 
		sum = sum + term
		term = term * x / (s + n)
		if term < 1e-15 then break end
	end
	return math.exp(-x) * sum * x ^ s
end

local function hypergeometric2F1(a, b, c, z)
	local sum = 1.0
	local term = 1.0
	local tolerance = 1e-6
	local count = 0
	for n = 1, 100000000 do 
		term = term * (a + n - 1) * (b + n - 1) / ((c + n - 1) * n) * z
		local newSum = sum + term
		if math.abs(newSum - sum) < tolerance then
			break
		end
		sum = newSum
		count = count + 1
	end
	return sum
end

local function logGamma(z)
	if z == 0.5 then
		return 0.5 * math.log(math.pi)
	elseif z > 0.5 then
		local term1 = 0.5 * (math.log(2 * math.pi) - math.log(z))
		local term2 = z * (math.log(z + 1 / (12 * z - 1 / (10 * z))) - 1)
		return term1 + term2
	else
		return math.log(math.pi) - math.log(math.sin(math.pi * z)) - logGamma(1 - z)
	end
end

local function Gamma(z) --lanczos
	local coefficients = {76.18009172947146, -86.50532032941677, 24.01409824083091, -1.231739572450155, 0.1208650973866179e-2, -0.5395239384953e-5}
	local y = z
	local tmp = z + 5.5
	tmp = (z + 0.5) * math.log(tmp) - tmp
	local a = 1.000000000190015
	for j = 1, 6 do
		y = y + 1
		a = a + coefficients[j] / y
	end
	return math.exp(tmp + math.log(2.5066282746310005 * a / z))
end

local function fPDF(x, df1, df2)
	local numerator = Gamma((df1 + df2) / 2) * (df1 / df2) ^ (df1 / 2) * x ^ ((df1 / 2) - 1)
	local denominator = Gamma(df1 / 2) * Gamma(df2 / 2) * (1 + (df1 / df2) * x) ^ (df1 / 2 + df2 / 2)
	return numerator / denominator
end

local function fPDF1(x, df1, df2)
	local logNumerator = logGamma((df1 + df2) / 2) + (df1 / 2) * math.log(df1 / df2) + ((df1 / 2) - 1) * math.log(x)
	local logDenominator = logGamma(df1 / 2) + logGamma(df2 / 2) + (df1 / 2 + df2 / 2) * math.log(1 + (df1 / df2) * x)
	local logPDF = logNumerator - logDenominator
	return math.exp(logPDF)
end

local function incompleteBeta1(a, b, x)
	return (math.pow(x, a) / a) * hypergeometric2F1(a, 1 - b, a + 1, x)
end

local function regularizedIncompleteBeta1(a, b, x)
	return incompleteBeta1(a, b, x) / (Gamma(a) * Gamma(b) / Gamma(a + b))
end 

local function regularizedIncompleteBeta11(a, b, x) -- for df > 340 overflow issue
	local logBeta = logGamma(a) + logGamma(b) - logGamma(a + b)
	return math.exp(math.log(incompleteBeta1(a, b, x)) - logBeta)
end

local function tDistCDF(t, nu)
	local x = nu / (t^2 + nu)
	local cdf
	if nu > 340 then
		cdf = 1 - 0.5 * regularizedIncompleteBeta11(nu / 2, 0.5, x)
	elseif nu > 200000 then
		cdf = module.normalCDF(t)
	else
		cdf = 1 - 0.5 * regularizedIncompleteBeta1(nu / 2, 0.5, x)
	end
	return cdf
end

local function fPValue(fStat, df1, df2) --simpsons rule
	if df1 == 1 then
		return 2 * (1 - tDistCDF(math.sqrt(fStat), df2))
	end
	if df1 == 2 and (df1 + df2) > 340 then
		local p = df2 / (df2 + df1 * fStat)
		local a = df2 / 2
		local b = df1 / 2
		return 	regularizedIncompleteBeta11(a, b, p)
	end
	local steps = 10000
	local a = 0
	local b = fStat
	local h = (b - a) / steps
	local sum
	if (df1 + df2) > 340 then
		sum = fPDF1(a, df1, df2) + fPDF1(b, df1, df2)
		for i = 1, steps - 1, 2 do
			sum = sum + 4 * fPDF1(a + i * h, df1, df2)
		end
		for i = 2, steps - 2, 2 do
			sum = sum + 2 * fPDF1(a + i * h, df1, df2)
		end
	else
		sum = fPDF(a, df1, df2) + fPDF(b, df1, df2)
		for i = 1, steps - 1, 2 do
			sum = sum + 4 * fPDF(a + i * h, df1, df2)
		end
		for i = 2, steps - 2, 2 do
			sum = sum + 2 * fPDF(a + i * h, df1, df2)
		end
	end
	local pValue = 1 - (h / 3) * sum
	if pValue < 1e-16 then
		pValue = 1e-16
	end
	if pValue > 1 then
		pValue = 1
	end
	return pValue
end

local function normalCDF(x, mu, sigma)
	if mu == nil then
		mu = 0
	end
	if sigma == nil then
		sigma = 1
	end
	local result = 0.5 * (1 + ErrorFunction((x - mu) / (sigma * math.sqrt(2))))
	if result > 1 then
		result = 1
	end
	if result < 1e-16 then
		result = 1e-16
	end
	return result
end

local function chiSquaredCDF(x, k)
	local cdf = lowerIncompleteGamma(k / 2, x / 2) / Gamma(k / 2)
	if cdf > 1 then
		cdf = 1
	end
	if cdf < 1e-16 then
		cdf = 1e-16
	end
	return cdf
end

local function LogInvCDF(cdf, mu, sigma)
	local erfInvValue = InverseErrorFunction(2 * cdf - 1)
	local lnx = sigma * math.sqrt(2) * erfInvValue + mu
	local x = math.exp(lnx)
	return x
end

local function CauchyInvCDF(cdf, x0, gamma)
	return x0 + gamma * math.tan(math.pi * (cdf - 0.5))
end

local function ExponentialInvCDF(cdf, lambda)
	return -math.log(1 - cdf) / lambda
end

local function numericalDerivative(f, x, h, lastDerivative)
	if x - h < 0 then
		return x, true
	end

	local derivative = (f(x + h) - f(x - h)) / (2 * h)
	lastDerivative = derivative
	return derivative
end

local function GammaInvCDF(cdf, alpha, Gamma, lowerIncompleteGamma)
	local lastDerivative = nil
	local x = 1
	local tolerance = 1e-6
	local iter = 1000
	local baseMaxStep = 1
	local scaledMaxStep
	local h
	for iteration = 1, iter do
		if x < 1 then
			h = 1e-14
		else
			h = 1e-6
		end
		scaledMaxStep = baseMaxStep * (1 + 0.1 / (1 + math.abs(x)))
		local cdfx = lowerIncompleteGamma(alpha, x) / Gamma(alpha)
		local errors = cdfx - cdf
		if math.abs(errors) < tolerance then
			return x
		end
		local derivativex, bools = numericalDerivative(function(u) return lowerIncompleteGamma(alpha, u) / Gamma(alpha) end, x, h, lastDerivative)
		if bools == true then
			return derivativex
		end
		local dx = -errors / derivativex
		dx = math.max(math.min(dx, scaledMaxStep), -scaledMaxStep)
		if x + dx < 0 then
			dx = -x / 2
		end
		x = x + dx
	end
	return nil
end

local function BetaInverseCDF(cdf, alpha, beta)
	local lastDerivative = nil
	local x = 0.5
	local tolerance = 5e-4
	local iter = 1000
	local baseMaxStep = 0.1
	local scaledMaxStep
	local h = 1e-10
	for i = 1, iter do
		scaledMaxStep = baseMaxStep * (1 + 0.1 / (1 + math.min(math.abs(x), math.abs(1 - x))))
		local cdfx = regularizedIncompleteBeta11(alpha, beta, x)
		local errors = cdfx - cdf
		if math.abs(errors) < tolerance then
			return x
		end
		local deriv, bools = numericalDerivative(function(u) return regularizedIncompleteBeta11(alpha, beta,u) end, x, h, lastDerivative)
		if bools == true then
			return deriv
		end
		local dx = -errors / deriv
		dx = math.max(math.min(dx, scaledMaxStep), -scaledMaxStep)
		if x + dx < 0 then
			dx = -x / 2
		end

		if x + dx > 1 then
			dx = (1 - x) / 2
		end

		x = x + dx
	end
	return nil
end

local function erfcinv(x)
	local term1 = -0.5 * math.sqrt(math.pi) * (x - 1)
	local term2 = -1 / 24 * math.pi ^ (3 / 2) * (x - 1) ^ 3
	local term3 = -7 / 960 * math.pi ^ (5 / 2) * (x - 1) ^ 5
	local term4 = -127 / 80640 * math.pi ^ (7 / 2) * (x - 1) ^ 7
	local term5 = -4369/7257600 * math.pi ^ (9 / 2) * (x - 1) ^ 9
	return term1 + term2 + term3 + term4 + term5
end

local function cdfNormalInv(p, sigma, mu)
	if mu == nil then
		mu = 0
	end
	if sigma == nil then
		sigma = 1
	end
	return mu + sigma * math.sqrt(2) * InverseErrorFunction(2 * p - 1)
end

local function extractColumns(matrix, columns, excludeIndex, addOnes)
	local subset = {}
	for i = 1, #matrix do
		local row = {}
		if addOnes then
			table.insert(row, 1)
		end
		if columns then
			for _, j in ipairs(columns) do
				table.insert(row, matrix[i][j])
			end
		else
			for j = 1, #matrix[i] do
				if j ~= excludeIndex then
					table.insert(row, matrix[i][j])
				end
			end
		end
		table.insert(subset, row)
	end
	return subset
end

local function tDistInv(targetP, nu) -- newtons derivative algorithm
	local lastDerivative = nil
	local x = 1.96 
	local tolerance = 5e-7
	local h = 1e-10 
	for i = 1, 1000 do
		local cdfx = tDistCDF(x, nu)
		local errors = cdfx - targetP
		if math.abs(errors) < tolerance then
			return x
		end
		local deriv = numericalDerivative(function(u) return tDistCDF(u, nu) end, x, h)
		local dx = -errors / deriv
		dx = dx
		x = x + dx
	end
	return nil
end

local function forwardRegression(X, Y, mseFull)
	local currentModel = {}
	local remainingPredictors = {}
	local bestCp = math.huge
	local bestModel = {}
	for i = 1, #X[1] do
		remainingPredictors[i] = i
	end
	while #remainingPredictors > 0 do
		local minCp = math.huge
		local minIndexIn = nil
		for _, predictor in ipairs(remainingPredictors) do
			local predictorSubset = {}
			for k, _ in pairs(currentModel) do
				table.insert(predictorSubset, k)
			end
			table.insert(predictorSubset, predictor)
			local subset = extractColumns(X, predictorSubset, nil, true)
			local SSE, n, k = module.multipleLinearRegression(subset, Y, false, nil, nil, nil, nil, nil, false, true, nil, nil,false)
			local Cp = SSE/mseFull - n + (2 * (k + 1))
			if Cp < minCp then
				minCp = Cp
				minIndexIn = predictor
			end
		end
		currentModel[minIndexIn] = true
		if minCp < bestCp then
			bestCp = minCp
			bestModel = {}
			for k, v in pairs(currentModel) do
				bestModel[k] = v
			end
		end
		for i, predictor in ipairs(remainingPredictors) do
			if predictor == minIndexIn then
				table.remove(remainingPredictors, i)
				break
			end
		end
	end
	return bestModel
end

local function deepCopy(orig)
	local origType = type(orig)
	local copy
	if origType == 'table' then
		copy = {}
		for origKey, origValue in next, orig, nil do
			copy[deepCopy(origKey)] = deepCopy(origValue)
		end
		setmetatable(copy, deepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

local function shapiroWilk(sample)
	if #sample < 4 then
		return false
	elseif #sample > 29 then
		return true
	end
	local sortedSample = {}
	for i, v in ipairs(sample) do
		sortedSample[i] = v
	end
	table.sort(sortedSample)
	local sampleMean = Mean(sortedSample)
	local S2 = 0
	for i, y in ipairs(sortedSample) do
		S2 = S2 + (y - sampleMean) ^ 2
	end
	local b = 0
	local n = #sortedSample
	local k = math.floor(n / 2)
	local aValues = {
		nil, nil, nil,
		{0.6873, 0.1663},
		{0.6646, 0.2414}, 
		{0.6430, 0.2807, 0.0883}, 
		{0.6231, 0.3030, 0.1411}, 
		{0.6051, 0.3163, 0.1751, 0.0565},
		{0.5887, 0.3243, 0.1982, 0.0951},
		{0.5737, 0.3290, 0.2143, 0.1228, 0.0401}, 
		{0.5600, 0.3315, 0.2260, 0.1433, 0.0698}, 
		{0.5474, 0.3326, 0.2345, 0.1589, 0.0924, 0.0304}, 
		{0.5358, 0.3327, 0.2408, 0.1709, 0.1101, 0.0540}, 
		{0.5250, 0.3320, 0.2455, 0.1804, 0.1242, 0.0729, 0.0240},  
		{0.5150, 0.3309, 0.2489, 0.1879, 0.1356, 0.0881, 0.0435}, 
		{0.5056, 0.3295, 0.2514, 0.1939, 0.1448, 0.1007, 0.0594, 0.0196}, 
		{0.4968, 0.3277, 0.2532, 0.1987, 0.1525, 0.1111, 0.0727, 0.0360},
		{0.4885, 0.3259, 0.2545, 0.2026, 0.1589, 0.1199, 0.0839, 0.0497, 0.0164},
		{0.4807, 0.3238, 0.2552, 0.2057, 0.1642, 0.1273, 0.0934, 0.0613, 0.0304},
		{0.4734, 0.3217, 0.2557, 0.2083, 0.1686, 0.1336, 0.1015, 0.0713, 0.0423, 0.0140}, 
		{0.4664, 0.3196, 0.2558, 0.2104, 0.1724, 0.1390, 0.1085, 0.0799, 0.0526, 0.0261}, 
		{0.4598, 0.3174, 0.2557, 0.2120, 0.1756, 0.1436, 0.1145, 0.0874, 0.0616, 0.0366, 0.0122}, 
		{0.4535, 0.3152, 0.2554, 0.2133, 0.1783, 0.1476, 0.1198, 0.0940, 0.0694, 0.0458, 0.0228}, 
		{0.4475, 0.3130, 0.2550, 0.2143, 0.1806, 0.1511, 0.1245, 0.0997, 0.0764, 0.0539, 0.0321, 0.0107}, 
		{0.4418, 0.3108, 0.2545, 0.2151, 0.1825, 0.1542, 0.1285, 0.1048, 0.0825, 0.0611, 0.0404, 0.0201},
		{0.4363, 0.3087, 0.2538, 0.2157, 0.1842, 0.1568, 0.1321, 0.1093, 0.0879, 0.0675, 0.0477, 0.0285, 0.0095}, 
		{0.4311, 0.3065, 0.2531, 0.2161, 0.1856, 0.1591, 0.1353, 0.1133, 0.0928, 0.0732, 0.0543, 0.0359, 0.0179}, 
		{0.4262, 0.3044, 0.2523, 0.2163, 0.1868, 0.1611, 0.1381, 0.1169, 0.0971, 0.0783, 0.0602, 0.0427, 0.0255, 0.0085}, 
		{0.4213, 0.3023, 0.2515, 0.2165, 0.1877, 0.1629, 0.1406, 0.1201, 0.1010, 0.0829, 0.0655, 0.0487, 0.0323, 0.0161},
	}
	for i = 1, k do
		b = b + aValues[n][i] * (sortedSample[n - i + 1] - sortedSample[i])
	end
	local W = (b * b) / S2
	local criticalValue = {nil, nil, nil, 0.7612, 0.7759, 0.7930, 0.8085, 0.8214, 0.8335, 0.8449, 0.8546, 0.8624, 0.8708, 0.8763, 0.8816, 0.8867, 0.8921, 0.896, 0.9008, 0.9043, 0.9079, 0.9112, 0.9135, 0.9171, 0.919, 0.9214, 0.9236, 0.9257, 0.9287}
	if W < criticalValue[n] then
		return false	
	end
	return true
end

local function leveneTest(groups)
	local k = #groups
	local N = 0
	local groupZMeans = {}
	local globalZMean = 0
	for i, group in ipairs(groups) do
		local Ni = #group
		N = N + Ni
		local groupMean = Mean(group)
		local groupZMean = 0
		for _, value in ipairs(group) do
			local Zij = math.abs(value - groupMean)
			groupZMean = groupZMean + Zij
			globalZMean = globalZMean + Zij
		end
		groupZMean = groupZMean / Ni
		table.insert(groupZMeans, groupZMean)
	end
	globalZMean = globalZMean / N
	local numerator = 0
	local denominator = 0
	for i, group in ipairs(groups) do
		local Ni = #group
		local groupMean = Mean(group)
		numerator = numerator + Ni * (groupZMeans[i] - globalZMean) ^ 2
		for _, value in ipairs(group) do
			local Zij = math.abs(value - groupMean) 
			denominator = denominator + (Zij - groupZMeans[i]) ^ 2
		end
	end
	local F = ((N - k) / (k - 1)) * (numerator / denominator)
	local dfNum = k - 1
	local dfDen = N - k
	local pValue = fPValue(F, dfNum, dfDen)
	local rejectH0 = conclusionStatement(pValue, 0.05)
	return pValue, not rejectH0
end

local function tTestOne(list, mu0, CL)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	if mu0 == nil then
		mu0 = 0
	end
	local mean = Mean(list)
	local tStat = (mean - mu0) / (StandardDeviation(list) / math.sqrt(#list))
	local df = #list - 1
	local pValue = 2 * (1 - tDistCDF(math.abs(tStat), df))
	local rejectH0 = conclusionStatement(pValue, alpha)
	local SE = StandardDeviation(list) / math.sqrt(#list)
	local tCritical = tDistInv(1 - alpha / 2, df)
	local MOE = tCritical * SE
	local lowerCI = mean - MOE
	local upperCI = mean + MOE
	return {pValue = pValue, rejectH0 = rejectH0, stat = tStat, df = df, center = mean, lowerCI = lowerCI, upperCI = upperCI, dependent = nil, parametric = true, nSamples = 1, testType = "One Sample t-Test", statType = "t", centerType = "Mean", postHoc = nil, postHocSig = nil, warning = nil}
end

local function signTest(list, eta0, CL)
	local n = #list
	local median = Median(list)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	if eta0 == nil then
		eta0 = 0
	end
	local nPlus = 0
	local nMinus = 0 
	for _, v in ipairs(list) do
		if v > eta0 then
			nPlus = nPlus + 1
		elseif v < eta0 then
			nMinus = nMinus + 1
		end
	end
	local nStar = nPlus + nMinus
	local pValue = 0 
	local bStar = math.max(nPlus, nStar - nPlus)
	for b = bStar, nStar do
		local res = 1
		for i = 1, b do
			res = res * (nStar - i + 1) / i
		end
		local binProb = res * 0.5 ^ b * 0.5 ^ (nStar - b)
		pValue = pValue + binProb
	end
	pValue = 2 * pValue
	local rejectH0 = conclusionStatement(pValue, alpha)
	local bootstrappedMedians = {}
	for i = 1, 100000 do
		local resample = {}
		for j = 1, n do
			local index = math.random(1, n)
			table.insert(resample, list[index])
		end
		local median = Median(resample)
		table.insert(bootstrappedMedians, median)
	end
	table.sort(bootstrappedMedians)
	local lowerIndex = math.ceil(100000 * (alpha / 2))
	local upperIndex = math.floor(100000 * (1 - alpha / 2))
	local lowerCI = bootstrappedMedians[lowerIndex]
	local upperCI = bootstrappedMedians[upperIndex]
	return {pValue = pValue, rejectH0 = rejectH0, stat = bStar, df = nil, center = {median}, centerComp = nil, lowerCI = lowerCI, upperCI = upperCI, dependent = nil, parametric = false, nSamples = 1, testType = "One Sample Sign Test", statType = "S", centerType = "Median", postHoc = nil, postHocSig = nil, warning = nil}
end

local function tTestTwoInd(list1, list2, CL) --satterwaithe appr. if variances not equal
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local df, pooledVariance, tStatistic
	local mean1 = Mean(list1)
	local mean2 = Mean(list2)
	local stdDev1 = StandardDeviation(list1)
	local stdDev2 = StandardDeviation(list2)
	local n1 = #list1
	local n2 = #list2
	local dfNum = n1 - 1
	local dfDen = n2 - 1
	local var1 = module.variance(list1)
	local var2 = module.variance(list2)
	local varRatio = var1/var2
	local pValueF
	if varRatio >= 1 then
		pValueF = 1 - fPValue(1 / varRatio, dfNum, dfDen) + fPValue(varRatio, dfNum, dfDen)
	end
	if varRatio < 1 then
		pValueF = 1 - fPValue(varRatio, dfNum, dfDen) + fPValue(1 / varRatio, dfNum, dfDen)
	end
	if pValueF < 0.05 then
		local numerator = ((var1 / n1) + (var2 / n2))^2
		local denominator = ((var1^2 / n1^2) / (n1 - 1)) + ((var2^2 / n2^2) / (n2 - 1))
		df = numerator / denominator
		tStatistic = (mean1 - mean2) / (math.sqrt(var1 / n1 + var2 / n2))
	else
		df = n1 + n2 - 2
		pooledVariance = ((stdDev1 ^ 2) * (n1 - 1) + (stdDev2 ^ 2) * (n2 - 1)) / df
		tStatistic = (mean1 - mean2) / (math.sqrt(pooledVariance * ((1/n1) + (1/n2))))
	end 
	local pValue = 2 * (1 - tDistCDF(math.abs(tStatistic), df))
	local tCritical = tDistInv(1 - (alpha / 2), df) 
	local SE = math.sqrt((var1 / n1) + (var2 / n2))
	local MOE = tCritical * SE 
	local lowerCI = (mean1 - mean2) - MOE
	local upperCI = (mean1 - mean2) + MOE
	local rejectH0 = conclusionStatement(pValue, alpha)
	return {pValue = pValue, rejectH0 = rejectH0, stat = tStatistic, df = df, center = {mean1, mean2}, centerComp = mean1 - mean2, lowerCI = lowerCI, upperCI = upperCI, independent = true, parametric = true, nSamples = 2, testType = "Two Sample Independent t-Test", statType = "t", centerType = "Mean", postHoc = nil, postHocSig = nil, warning = nil}
end

local function tTestTwoDep(list1, list2, CL)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	if #list1 ~= #list2 then
		error("The lists have to be the same length.")
	end
	local differences = {}
	for i = 1, #list1 do
		table.insert(differences, list1[i] - list2[i])
	end
	local mean1 = Mean(list1)
	local mean2 = Mean(list2)
	local meanDifference = Mean(differences)
	local stDev = StandardDeviation(differences)
	local tStatistic = meanDifference / (stDev / math.sqrt(#differences))
	local df = #differences - 1
	local pValue = 2 * (1 - tDistCDF(math.abs(tStatistic), df))
	local tCritical = tDistInv(1 - alpha / 2, df)
	local MOE = tCritical * (stDev / math.sqrt(#list1))
	local lowerCI = meanDifference - MOE
	local upperCI = meanDifference + MOE
	local rejectH0 = conclusionStatement(pValue, alpha)
	return {pValue = pValue, rejectH0 = rejectH0, stat = tStatistic, df = df, center = {mean1, mean2}, centerComp = meanDifference, lowerCI = lowerCI, upperCI = upperCI, independent = false, parametric = true, nSamples = 2, testType = "Two Sample Dependent t-Test", statType = "t", centerType = "Mean", postHoc = nil, postHocSig = nil, warning = nil}
end

local function rankSum(sample1, sample2, CL, postHoc)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local median1 = Median(sample1)
	local median2 = Median(sample2)
	local medianDifference = median1 - median2
	local combined = {}
	for _, v in ipairs(sample1) do
		table.insert(combined, {value = v, group = 1})
	end
	for _, v in ipairs(sample2) do
		table.insert(combined, {value = v, group = 2})
	end
	table.sort(combined, function(a, b) return a.value < b.value end)
	local n = #combined
	local i = 1
	local sumTies = 0  
	while i <= n do
		local j = i
		local sumRank = 0
		local nTies = 0
		while j <= n and combined[j].value == combined[i].value do
			sumRank = sumRank + j
			j = j + 1
			nTies = nTies + 1
		end
		local avgRank = sumRank / nTies
		if nTies > 1 then
			sumTies = sumTies + (nTies ^ 3 - nTies) 
		end
		for k = i, j - 1 do
			combined[k].rank = avgRank
		end
		i = j
	end
	local W1, W2 = 0, 0
	for _, c in ipairs(combined) do
		if c.group == 1 then
			W1 = W1 + c.rank
		else
			W2 = W2 + c.rank
		end
	end
	local W = W1 - (#sample1 * (#sample1 + 1)) / 2
	local n1, n2 = #sample1, #sample2
	local Z = W - n1 * n2 / 2
	local sigma = math.sqrt((n1 * n2 / 12) * ((n1 + n2 + 1) - sumTies / ((n1 + n2) * (n1 + n2 - 1))))  
	local zSign = Z / math.abs(Z)
	Z = (Z - zSign * 0.5) / sigma -- with continuity correction
	local pValue = 2 * (1 - normalCDF(math.abs(Z)))
	local rejectH0 = conclusionStatement(pValue, alpha)
	local warning
	if #sample1 < 10 or #sample2 < 10 then
		warning = true
	else
		warning = nil
	end
	local lowerCI, upperCI
	if (postHoc ~= true) then
		local bootstrapDifferences = {}
		for i = 1, 100000 do
			local resample1 = {}
			local resample2 = {}
			for j = 1, #sample1 do
				table.insert(resample1, sample1[math.random(#sample1)])
			end
			for j = 1, #sample2 do
				table.insert(resample2, sample2[math.random(#sample2)])
			end
			local medianboot1 = Median(resample1)
			local medianboot2 = Median(resample2)
			local dif = medianboot1 - medianboot2
			table.insert(bootstrapDifferences, dif)
		end
		table.sort(bootstrapDifferences)
		local lowerIndex = math.ceil(#bootstrapDifferences * alpha / 2)
		local upperIndex = math.floor(#bootstrapDifferences * (1 - alpha / 2))
		lowerCI = bootstrapDifferences[lowerIndex]
		upperCI = bootstrapDifferences[upperIndex]
	end
	return {pValue = pValue, rejectH0 = rejectH0, stat = W, df = nil, center = {median1, median2}, centerComp = medianDifference, lowerCI = lowerCI, upperCI = upperCI, independent = true, parametric = false, nSamples = 2, testType = "Two Sample Rank-Sum Test", statType = "W", centerType = "Median", postHoc = nil, postHocSig = nil, warning = warning}
end

local function signedRank(sample1, sample2, CL, postHoc)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	if #sample1 ~= #sample2 then
		error("The lists are not the same")
	end
	local median1 = Median(sample1)
	local median2 = Median(sample2)
	local differences = {}
	local absoluteDifferences = {}
	local n = 0
	for i = 1, #sample1 do
		local dif = sample1[i] - sample2[i]
		if dif ~= 0 then
			table.insert(differences, dif)
			table.insert(absoluteDifferences, {index = n + 1, value = math.abs(dif)})
			n = n + 1
		end
	end
	table.sort(absoluteDifferences, function(a, b) return a.value < b.value end)
	local ranks = {}
	local sumTies = 0
	local i = 1
	while i <= #absoluteDifferences do
		local j = i
		local sumRank = 0
		local nTies = 0
		while j <= #absoluteDifferences and absoluteDifferences[j].value == absoluteDifferences[i].value do
			sumRank = sumRank + j
			j = j + 1
			nTies = nTies + 1
		end
		local avgRank = sumRank / (j - i)
		if nTies > 1 then
			sumTies = sumTies + (nTies ^ 3 - nTies)
		end
		for k = i, j - 1 do
			ranks[absoluteDifferences[k].index] = avgRank
		end
		i = j
	end
	local V = 0
	for i, v in ipairs(differences) do
		if v > 0 then
			V = V + ranks[i]
		end
	end
	local mu = V - (n * (n + 1)) / 4
	local sign = mu/math.abs(mu)
	local var = (n * (n + 1) * (2 * n + 1)) / 24 - sumTies / 48
	local Z = (mu - sign * 0.5) / math.sqrt(var)
	local pValue = 2 * (1 - normalCDF(math.abs(Z)))
	local rejectH0 = conclusionStatement(pValue, alpha)
	table.sort(differences)
	local pseudomedian = Median(differences)
	local lowerCI, upperCI
	if (postHoc ~= true) then
		local bootstrapPseudomedians = {}
		for b = 1, 100000 do
			local sampleDiff = {}
			for j = 1, #differences do
				local index = math.random(#differences)
				table.insert(sampleDiff, differences[index])
			end
			table.sort(sampleDiff)
			local bootstrapPseudomedian = Median(sampleDiff)
			table.insert(bootstrapPseudomedians, bootstrapPseudomedian)
		end
		table.sort(bootstrapPseudomedians)
		local lowerIndexPseudo = math.ceil(100000 * (alpha / 2))
		local upperIndexPseudo = math.floor(100000 * (1 - alpha / 2))
		lowerCI = bootstrapPseudomedians[lowerIndexPseudo]
		upperCI = bootstrapPseudomedians[upperIndexPseudo]
	end
	return {pValue = pValue, rejectH0 = rejectH0, stat = V, df = nil, center = {median1, median2}, centerComp = pseudomedian, lowerCI = lowerCI, upperCI = upperCI, independent = false, parametric = false, nSamples = 2, testType = "Two Sample Signed-Rank Test", statType = "V", centerType = "Median", postHoc = nil, postHocSig = nil, warning = nil, differences = differences}
end

local function largeSampleProportionTest(k, n, p, CL)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local pHat = (k + 2) / (n + 4)
	local standardError = math.sqrt((pHat * (1 - pHat)) / (n + 4))
	local zInv = cdfNormalInv(alpha/2)	
	local lowerCI = pHat - zInv * standardError
	local upperCI = pHat + zInv * standardError
	local Z = (pHat - p) / math.sqrt((p * (1 - p)) / n)
	local pValue = 2 * (1 - normalCDF(math.abs(Z)))
	local rejectH0 = conclusionStatement(pValue, alpha)
	return {pValue = pValue, rejectH0 = rejectH0, stat = Z, df = 1, pTest = p, pHat = pHat, lowerCI = lowerCI, upperCI = upperCI, parametric = true, testType = "Large Sample Proportion Test", statType = "Z", warning = nil}
end

local function exactBinomialTest(x, n, p, CL)
	local function binomialCDF(x, n, p)
		local sum = 0
		for i = 0, x do
			sum = sum + math.exp(logFactorial(n) - logFactorial(i) - logFactorial(n - i) + i * math.log(p) + (n - i) * math.log(1 - p))
		end
		return sum
	end
	local alpha, pValue
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	if p == 0 then
		return x == 0 and 1 or 0
	elseif p == 1 then
		return x == n and 1 or 0
	end
	local relErr = 1 + 1e-7
	local d = math.exp(logFactorial(n) - logFactorial(x) - logFactorial(n - x) + x * math.log(p) + (n - x) * math.log(1 - p))
	local m = n * p
	if x == m then
		return 1
	end
	local y
	if x < m then
		y = 0
		for i = math.ceil(m), n do
			if math.exp(logFactorial(n) - logFactorial(i) - logFactorial(n - i) + i * math.log(p) + (n - i) * math.log(1 - p)) <= d * relErr then
				y = y + 1
			end
		end
		pValue = binomialCDF(x, n, p) + 1 - binomialCDF(n - y, n, p)
	else
		y = 0
		for i = 0, math.floor(m) do
			if math.exp(logFactorial(n) - logFactorial(i) - logFactorial(n - i) + i * math.log(p) + (n - i) * math.log(1 - p)) <= d * relErr then
				y = y + 1
			end
		end
		pValue = binomialCDF(y - 1, n, p) + 1 - binomialCDF(x - 1, n, p)
	end
	-- I have to correct the algorithm for the beta inverse CDF. It is very difficult to implement.
	-- For now, this binomial test cannot provide a proper CI.
	--[[
	local lowerCI, upperCI
	if k == 0 then
		lowerCI = 0
	else
		lowerCI = BetaInverseCDF(alpha / 2, k, n - k + 1)
	end
	if k == n then
		upperCI = 1
	else
		upperCI = BetaInverseCDF(1 - alpha / 2, k + 1, n - k)
	end]]
	local rejectH0 = conclusionStatement(pValue, alpha)
	return {pValue = pValue, rejectH0 = rejectH0, stat = nil, df = nil, pTest = p, pHat = x / n, lowerCI = nil, upperCI = nil, parametric = false, testType = "Exact Binomial Test", statType = nil, warning = nil}
end

local function postHocBonferroniANOVA(groups, alpha, totaldf, MSE)
	local k = #groups
	local comparisons = k * (k - 1) / 2
	alpha = alpha / comparisons 
	local results = {}
	local results2 = {}
	for i = 1, k - 1 do
		for j = i + 1, k do
			local mean1 = Mean(groups[i])
			local mean2 = Mean(groups[j])
			local stDev1 = StandardDeviation(groups[i])
			local stDev2 = StandardDeviation(groups[j])
			local n1 = #groups[i]
			local n2 = #groups[j]
			local df = n1 + n2 - 2
			local pooledVariance = ((stDev1 ^ 2) * (n1 - 1) + (stDev2 ^ 2) * (n2 - 1)) / df
			local t = (mean1 - mean2) / (math.sqrt(pooledVariance * ((1/n1) + (1/n2))))
			local tStat = math.abs(t)
			local pValue = 2 * (1 - tDistCDF(tStat, df))
			if pValue < 1e-16 then
				pValue = 1e-16
			end
			if pValue > 1 then
				pValue = 1
			end
			local tCritical = tDistInv(1 - (alpha / 2), df) 
			local SE = math.sqrt((stDev1 ^ 2 / n1) + (stDev2 ^ 2 / n2))
			local MOE = tCritical * SE 
			local lowerCI = (mean1 - mean2) - MOE
			local upperCI = (mean1 - mean2) + MOE
			local hyp = conclusionStatement(pValue, alpha)
			table.insert(results, {group1 = i, group2 = j, pValue = pValue, alpha = alpha, rejectH0 = hyp, t, df, centerComp = mean1 - mean2, lowerCI, upperCI, center = {[i] = mean1,[j] = mean2}, warning = nil, testType = "Two Sample Independent t-Test", statType = "t", centerType = "Mean"})
			if hyp == true then
				table.insert(results2, {group1 = i, group2 = j, pValue = pValue, alpha = alpha, rejectH0 = hyp, t, df, centerComp = mean1 - mean2, lowerCI, upperCI, center = {[i] = mean1,[j] = mean2}, warning = nil, testType = "Two Sample Independent t-Test", statType = "t", centerType = "Mean"})
			end
		end
	end
	return results, results2
end


local function ANOVA(groups, CL)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local k = #groups 
	local n = 0
	local totalMean = 0
	local SSB = 0 
	local SSW = 0 
	local groupMeans = {}
	for i, group in ipairs(groups) do
		n = n + #group
		local groupMean = Mean(group)
		groupMeans[i] = groupMean
		totalMean = totalMean + groupMean * #group
	end
	totalMean = totalMean / n
	for i, group in ipairs(groups) do
		local groupMean = groupMeans[i]
		SSB = SSB + (#group * (groupMean - totalMean) ^ 2)
		local sum = 0
		for i, v in ipairs(group) do
			sum = sum + (v - groupMean) ^ 2
		end
		SSW = SSW + sum
	end
	local dfB = k - 1
	local dfW = n - k
	local MSB = SSB / dfB
	local MSW = SSW / dfW
	local F = MSB / MSW
	local pValue = fPValue(F, dfB, dfW)
	local rejectH0 = conclusionStatement(pValue, alpha)
	local postHocResults, postHocResults2 = postHocBonferroniANOVA(groups, alpha, n, MSW)
	return {pValue = pValue, rejectH0 = rejectH0, stat = F, df = {dfB, dfW}, center = groupMeans, centerComp = nil, lowerCI = nil, upperCI = nil, independent = true, parametric = true, nSamples = #groups, testType = "ANOVA Test", statType = "F", centerType = "Mean", postHoc = postHocResults, postHocSig = postHocResults2, warning = nil}
end

local function postHocBonferroniKruskalWallis(groups, CL)
	local k = #groups
	local comparisons = k * (k - 1) / 2
	local alpha
	if CL == nil then
		alpha = 0.05 / comparisons
	else
		alpha = (1 - CL) / comparisons
	end
	local results = {}
	local results2 = {}
	local bootNum = 100000 / comparisons ^ 0.7
	for i = 1, k - 1 do
		for j = i + 1, k do
			local indResult = rankSum(groups[i], groups[j], CL, true)
			local bootstrapDifferences = {}
			for l = 1, bootNum do
				local resample1 = {}
				local resample2 = {}
				for m = 1, #groups[i] do
					table.insert(resample1, groups[i][math.random(#groups[i])])
				end
				for m = 1, #groups[j] do
					table.insert(resample2, groups[j][math.random(#groups[j])])
				end
				local median1 = Median(resample1)
				local median2 = Median(resample2)
				local dif = median1 - median2
				table.insert(bootstrapDifferences, dif)
			end
			table.sort(bootstrapDifferences)
			local lowerIndex = math.ceil(#bootstrapDifferences * alpha / 2)
			local upperIndex = math.floor(#bootstrapDifferences * (1 - alpha / 2))
			local lowerCI = bootstrapDifferences[lowerIndex]
			local upperCI = bootstrapDifferences[upperIndex]
			local hyp = conclusionStatement(indResult["pValue"], alpha)
			table.insert(results, {group1 = i, group2 = j, pValue = indResult["pValue"], alpha = alpha, rejectH0 = hyp, stat = indResult["stat"], df = nil, centerComp = indResult["centerComp"], center = {[i] = indResult["center"][1],[j] = indResult["center"][2]}, lowerCI = lowerCI, upperCI = upperCI, testType = indResult["testType"], statType = indResult["statType"], centerType = indResult["centerType"]})
			if hyp == true then
				table.insert(results2, {group1 = i, group2 = j, pValue = indResult["pValue"], alpha = alpha, rejectH0 = hyp, stat = indResult["stat"], df = nil, centerComp = indResult["centerComp"], center = {[i] = indResult["center"][1],[j] = indResult["center"][2]}, lowerCI = lowerCI, upperCI = upperCI, testType = indResult["testType"], statType = indResult["statType"], centerType = indResult["centerType"]})	
			end
		end
	end
	return results, results2
end

local function kruskalWallis(groups, CL)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local allData = {}
	local mediansTable = {}
	local Ri = {}
	local n = 0
	for i, group in ipairs(groups) do
		local medianGroup = Median(group)
		mediansTable[i] = medianGroup
		n = n + #group
		for j, value in ipairs(group) do
			table.insert(allData, value)
		end
	end
	table.sort(allData)
	local i = 1
	local sumTies = 0
	while i <= #allData do
		local nTies = 0
		local j = i
		local sumRanks = 0
		while j <= #allData and allData[j] == allData[i] do
			sumRanks = sumRanks + j
			j = j + 1
			nTies = nTies + 1
		end
		local avgRank = sumRanks / nTies
		if nTies > 1 then
			sumTies = sumTies + (nTies ^ 3 - nTies) 
		end
		for k = i, j - 1 do
			allData[k] = {value = allData[k], rank = avgRank}
		end
		i = j
	end
	for i, group in ipairs(groups) do
		local sumRanks = 0
		for j, value in ipairs(group) do
			for _, data in ipairs(allData) do
				if data.value == value then
					sumRanks = sumRanks + data.rank
					break
				end
			end
		end
		Ri[i] = sumRanks
	end
	local H = 0
	for i, sumRanks in ipairs(Ri) do
		local ni = #groups[i]
		H = H + (sumRanks ^ 2) / ni
	end
	H = ((12 * H / (n * (n + 1))) - 3 * (n + 1)) / (1 - sumTies / (n ^ 3 - n))
	local df = #groups - 1
	local pValue = 1 - chiSquaredCDF(H,df)
	local rejectH0 = conclusionStatement(pValue, alpha)
	local postHocResults, postHocResults2 = postHocBonferroniKruskalWallis(groups, CL)
	return {pValue = pValue, rejectH0 = rejectH0, stat = H, df = df, center = mediansTable, centerComp = nil, lowerCI = nil, upperCI = nil, independent = true, parametric = false, nSamples = #groups, testType = "Kruskal-Wallis Test", statType = "Chi-Square", centerType = "Median", postHoc = postHocResults, postHocSig = postHocResults2, warning = nil}
end

local function postHocBonferroniFriedman(groups, CL)
	local k = #groups
	local comparisons = k * (k - 1) / 2
	local alpha
	if CL == nil then
		alpha = 0.05 / comparisons
	else
		alpha = (1 - CL) / comparisons
	end
	local results = {}
	local results2 = {}
	local bootNum = 100000 / comparisons ^ 0.7
	for i = 1, k - 1 do
		for j = i + 1, k do
			local indResult = signedRank(groups[i], groups[j], CL, nil, true)
			local bootstrapPseudomedians = {}
			for b = 1, bootNum do
				local sampleDiff = {}
				for j = 1, #groups[i] do
					local index = math.random(#groups[i])
					table.insert(sampleDiff, indResult["differences"][index])
				end
				table.sort(sampleDiff)
				local bootstrapPseudomedian = Median(sampleDiff)
				table.insert(bootstrapPseudomedians, bootstrapPseudomedian)
			end
			table.sort(bootstrapPseudomedians)
			local lowerIndexPseudo = math.ceil(bootNum * (alpha / 2))
			local upperIndexPseudo = math.floor(bootNum * (1 - alpha / 2))
			local lowerCI = bootstrapPseudomedians[lowerIndexPseudo]
			local upperCI = bootstrapPseudomedians[upperIndexPseudo]
			local hyp = conclusionStatement(indResult["pValue"], alpha)
			table.insert(results, {group1 = i, group2 = j, pValue = indResult["pValue"], alpha = alpha, rejectH0 = hyp, stat = indResult["stat"], df = nil, centerComp = indResult["centerComp"], center = {[i] = indResult["center"][1],[j] = indResult["center"][2]}, lowerCI = lowerCI, upperCI = upperCI, testType = indResult["testType"], statType = indResult["statType"], centerType = indResult["centerType"]})
			if hyp == true then
				table.insert(results2, {group1 = i, group2 = j, pValue = indResult["pValue"], alpha = alpha, rejectH0 = hyp, stat = indResult["stat"], df = nil, centerComp = indResult["centerComp"], center = {[i] = indResult["center"][1],[j] = indResult["center"][2]}, lowerCI = lowerCI, upperCI = upperCI, testType = indResult["testType"], statType = indResult["statType"], centerType = indResult["centerType"]})	
			end
		end
	end
	return results, results2
end


local function Rank(arr)
	local rank = {}
	local sorted = {}
	for i, v in ipairs(arr) do
		table.insert(sorted, {index = i, value = v})
	end
	table.sort(sorted, function(a, b) return a.value < b.value end)
	local currentRank = 1
	for i = 1, #sorted do
		if i > 1 and sorted[i].value == sorted[i-1].value then
			currentRank = currentRank + 0.5
		else
			currentRank = i
		end
		rank[sorted[i].index] = currentRank
	end
	return rank
end

-- Main function for Friedman Test
local function friedmanTest(groups, CL)
	local warning
	if #groups[1] < 4 or #groups < 15 then
		warning = true
	end

	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local mediansTable = {}
	for i, group in ipairs(groups) do
		local med = Median(group)
		mediansTable[i] = med
	end
	local k = #groups
	local n = #groups[1]
	local sumRanks = {}
	local tiesSum = 0
	for j = 1, n do
		local row = {}
		for i = 1, k do
			table.insert(row, groups[i][j])
		end
		local r = Rank(row)
		for i = 1, k do
			sumRanks[i] = (sumRanks[i] or 0) + r[i]
		end
		local TIES = {}
		for _, v in pairs(r) do
			TIES[v] = (TIES[v] or 0) + 1
		end
		for _, count in pairs(TIES) do
			tiesSum = tiesSum + (count ^ 3 - count)
		end
	end
	local chiSquaredNumerator = 0
	for i = 1, k do
		chiSquaredNumerator = chiSquaredNumerator + ((sumRanks[i] - n * (k + 1) / 2) ^ 2)
	end
	local chiSquared = (12 * chiSquaredNumerator) / (n * k * (k + 1)) - (tiesSum / (k - 1))
	local df = k - 1
	local pValue = 1 - chiSquaredCDF(chiSquared, df)
	local rejectH0 = conclusionStatement(pValue, alpha)
	local postHocResults, postHocResults2 = postHocBonferroniFriedman(groups, CL)
	return {pValue = pValue, rejectH0 = rejectH0, stat = chiSquared, df = df, center = mediansTable, centerComp = nil, lowerCI = nil, upperCI = nil, independent = false, parametric = false, nSamples = #groups, testType = "Friedman Test", statType = "Chi-Square", centerType = "Median", postHoc = postHocResults, postHocSig = postHocResults2, warning = warning}
end

local function oneSample(list, mu0, CL)
	if shapiroWilk(list) then
		return tTestOne(list, mu0, CL)
	else
		return signTest(list, mu0, CL)
	end
end

local function twoSampleDep(list1, list2, CL)
	if (shapiroWilk(list1) and shapiroWilk(list2)) then
		return tTestTwoDep(list1, list2, CL)
	else
		return signedRank(list1, list2, CL)
	end
end

local function twoSampleInd(list1, list2, CL)
	if (shapiroWilk(list1) and shapiroWilk(list2)) then
		return tTestTwoInd(list1, list2, CL)
	else
		return rankSum(list1, list2, CL)
	end
end

local function threePlusSampleInd(lists, CL)
	for _, list in pairs(lists) do
		if not shapiroWilk(list) then
			return kruskalWallis(lists, CL)
		end
	end
	if not leveneTest(lists) then
		return kruskalWallis(lists, CL)
	end
	return ANOVA(lists, CL)
end

-- USEABLE FUNCTIONS

-- BASIC STATISTICS

function module.sumOfSquares(list)
	local mean = Mean(list)
	local sum = 0
	for i, v in ipairs(list) do
		sum = sum + (v - mean) ^ 2
	end
	return sum
end

function module.mean(values)
	local mea = Mean(values)
	return mea
end

function module.median(values)
	local med = Median(values)
	return med
end

function module.mode(values)
	local mod = Mode(values)
	return mod
end

function module.range(values)
	local ran = Range(values)
	return ran
end

function module.standardDeviation(values)
	local sd = StandardDeviation(values)
	return sd
end

function module.variance(values)
	local var = StandardDeviation(values) ^ 2
	return var
end

function module.interquartileRange(values)
	local IQR = InterquartileRange(values)
	return IQR
end

function module.factorial(x)
	local fac = Factorial(x)
	return fac
end

-- SOLVE COMPLICATED FUNCTIONS

function module.erf(x)
	local err = ErrorFunction(x)
	return err
end

function module.inverf(x)
	local inv = InverseErrorFunction(x)
	return inv
end

function module.gamma(x)
	local gam = Gamma(x)
	return gam
end

function module.hypergeometric2f1(a, b, c, z)
	local hypergeom = hypergeometric2F1(a, b, c, z)
	return hypergeom
end

function module.incompleteBeta(a,b,x)
	local incbeta = incompleteBeta1(a,b,x)
	return incbeta
end

function module.regularizedIncompleteBeta(a, b, x)
	local regincbeta = regularizedIncompleteBeta1(a, b, x)
	return regincbeta
end

-- HYPOTHESIS TESTS

function module.inference(list, independent, CL, mu0)
	if list[1] == nil then
		warn("There was nothing to test in list")
		return nil
	elseif list[2] == nil then
		return oneSample(list[1], mu0, CL)
	elseif list[3] == nil then
		if independent == false then
			return twoSampleDep(list[1], list[2], CL)
		else
			return twoSampleInd(list[1], list[2], CL)
		end
	else
		if independent == false then
			return friedmanTest(list, CL)
		else
			return threePlusSampleInd(list, CL)
		end
	end
end

function module.oddsRatio(O11, O12, O21, O22, CL)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local OR = (O11 / O12) / (O21 / O22)
	local sigma = math.sqrt(1 / O11 + 1 / O12 + 1 / O21 + 1 / O22)
	local Z = cdfNormalInv(1 - alpha/2)
	local lnOR = math.log(OR)
	local lowerBound = math.exp(lnOR - Z * sigma)
	local upperBound = math.exp(lnOR + Z * sigma)
	local rejectH0
	if lowerBound < 1 and upperBound > 1 then
		rejectH0 = false
	else
		rejectH0 = true
	end
	return {OR = OR, rejectH0 = rejectH0, lowerCI = lowerBound, upperCI = upperBound}
end

function module.oneSampleProportionCI(k, n, CL) --uses WAC
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local pHat = (k + 2) / (n + 4)
	local standardError = math.sqrt((pHat * (1 - pHat)) / (n + 4))
	local zInv = cdfNormalInv(1 - alpha/2)	
	local lowerCI = pHat - zInv * standardError
	local upperCI = pHat + zInv * standardError
	return {pHat = pHat, lowerCI = lowerCI, upperCI = upperCI, testType = "One Sample Proportion CI"}
end

function module.singleProportionInference(k, n, p, CL)
	if (n * p) >= 5 and (n * (1 - p)) >= 5 then
		return largeSampleProportionTest(k, n, p, CL)
	else
		return exactBinomialTest(k, n, p, CL)
	end
end

function module.twoProportionInference(k1, n1, k2, n2, CL)
	local alpha, warning
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local pHat1 = k1 / n1
	local pHat2 = k2 / n2
	local pHat = (k1 + k2) / (n1 + n2)
	if n1 * pHat < 5 or n2 * pHat < 5 or n1 * (1 - pHat) < 5 or n2 * (1 - pHat) < 5 then
		warning = true
	else
		warning = nil
	end
	local standardError = math.sqrt(pHat * (1 - pHat) * (1 / n1 + 1 / n2))
	local zInv = cdfNormalInv(alpha / 2)
	local lowerCI = math.max(pHat1 - pHat2 - zInv * math.sqrt(pHat1 * (1 - pHat1) / n1 + pHat2 * (1 - pHat2) / n2), -1)
	local upperCI = math.min(pHat1 - pHat2 + zInv * math.sqrt(pHat1 * (1 - pHat1) / n1 + pHat2 * (1 - pHat2) / n2), 1)
	local Z = (pHat1 - pHat2) / standardError
	local pValue = 2 * (1 - normalCDF(math.abs(Z)))
	local rejectH0 = conclusionStatement(pValue, alpha)
	return {pValue = pValue, rejectH0 = rejectH0, stat = Z, df = nil, pTest = nil, pHat = {pHat1, pHat2, pHat}, lowerCI = upperCI, upperCI = lowerCI, parametric = true, testType = "Two Proportion Test", statType = "Z", warning = warning}
end

function module.goodnessOfFit(observed, expectedProportions, CL)
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local warning = nil
	local allGreaterOrEqualFive = true
	local countLessThanFive = 0
	local n = 0
	for i, v in ipairs(observed) do
		n = n + v
	end
	local chiSquared = 0
	for i, v in ipairs(observed) do
		local Ei = n * expectedProportions[i]
		local Oi = v
		chiSquared = chiSquared + ((Oi - Ei)^2) / Ei
		if Ei < 5 then
			allGreaterOrEqualFive = false
			if Ei < 1 then
				warning = true
			end
			countLessThanFive = countLessThanFive + 1
		end
	end
	if not allGreaterOrEqualFive then
		if countLessThanFive / #expectedProportions > 0.2 then
			warning = true
		end
	end
	local df = #observed - 1 
	local pValue = 1 - chiSquaredCDF(chiSquared, df)
	local rejectH0 = conclusionStatement(pValue, alpha)
	return {pValue = pValue, rejectH0 = rejectH0, stat = chiSquared, df = df, parametric = true, testType = "Pearson's Goodness of Fit Test", statType = "Chi-Square", warning = warning}
end

function module.chiSquareIndependence(matrix, CL)
	local alpha
	local warnStatement = false
	local warning = nil -- Haven't figured how to implement Fisher's Exact Test, therefore, I must warn if assumptions not met
	local warningCount = 0
	local count = 0
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	local r = #matrix
	local c = #matrix[1]  

	local Ri = {} 
	local Cj = {} 
	local n = 0  

	for i = 1, r do
		Ri[i] = 0
		for j = 1, c do
			Ri[i] = Ri[i] + matrix[i][j]
		end
		n = n + Ri[i]
	end

	for j = 1, c do
		Cj[j] = 0
		for i = 1, r do
			Cj[j] = Cj[j] + matrix[i][j]
		end
	end

	local chiSquaredStat = 0 
	for i = 1, r do
		for j = 1, c do
			local Eij = (Ri[i] * Cj[j]) / n  
			if Eij < 1 then
				warning = true
			end
			if Eij < 5 then
				warningCount = warningCount + 1
			end
			count = count + 1
			local Oij = matrix[i][j] 
			chiSquaredStat = chiSquaredStat + ((Oij - Eij)^2) / Eij
		end
	end
	local df = (r - 1) * (c - 1) 
	local pValue = 1 - chiSquaredCDF(chiSquaredStat, df)
	local rejectH0 = conclusionStatement(pValue, alpha)
	local warningJudgement = (warningCount / count > 0.2)
	if warningJudgement == true or warning == true then
		warnStatement = true
	else
		warnStatement = nil
	end
	return {pValue = pValue, rejectH0 = rejectH0, stat = chiSquaredStat, df = df, parametric = true, testType = "Pearson's Test for Independence/Homogeneity", statType = "Chi-Square", warning = warning}
end

--regression uses mallow's cp as selection criterion

function module.multipleLinearRegression(X, Y, forwardReg, diagnostics, CL, CI, PI, significantBTrack, addOnesColumn, forward, mseCheck, VIFs, first)
	if first == nil then
		first = true
	end
	local alpha
	if CL == nil then
		alpha = 0.05
	else
		alpha = 1 - CL
	end
	if forwardReg == nil then
		forwardReg = true
	end
	if diagnostics == nil then
		diagnostics = true
	end
	if diagnostics == true then
		VIFs = true
	end
	if first == true then
		for i = 1, #Y do
			Y[i] = {Y[i]}
		end
	end
	if forwardReg == false then
		if addOnesColumn ~= false then 
			for i = 1, #X do
				table.insert(X[i], 1, 1)
			end
		end 
	end
	if forwardReg == true then
		local copy = deepCopy(X)
		local mseFull = module.multipleLinearRegression(copy, Y, false, nil, nil, nil, nil, nil, true, false, true, nil, false)
		local bestModel = forwardRegression(X, Y, mseFull)
		local indices = {}
		for k, _ in pairs(bestModel) do
			table.insert(indices, k)
		end
		local XSubset = extractColumns(X, indices)
		local VIFs = {}
		for i = 1, #XSubset[1] do
			local subSubsetX = extractColumns(XSubset, {i})
			local otherX = extractColumns(XSubset, nil, i)
			local lm = module.multipleLinearRegression(otherX, subSubsetX, false, true,nil,nil,nil,nil,true,false,false,nil, false)
			local rSquared = lm["r2"]
			local VIF = 1 / (1 - rSquared)
			if VIF > 10 then
				VIFs[indices[i]] = {VIF = VIF, summaryVIF = "*Multicollinearity*"}
			elseif VIF > 5 then
				VIFs[indices[i]] = {VIF = VIF, summaryVIF = "Possible Multicollinearity"}
			else
				VIFs[indices[i]] = {VIF = VIF, summaryVIF = "Little/No Multicollinearity"}
			end
		end
		local newModel
		if diagnostics == true then
			newModel = module.multipleLinearRegression(XSubset, Y, false, true, nil, nil, nil, nil, true, false, false, VIFs, false)
		else
			newModel = module.multipleLinearRegression(XSubset, Y, false, nil, nil, nil, nil, nil, true, nil, nil, nil, false)
		end
		newModel["VIFs"] = VIFs
		local origModel
		if diagnostics == true then
			origModel = module.multipleLinearRegression(copy, Y, false, true, nil, nil, nil, nil, false, false,nil,nil,false)
		end
		if diagnostics == true then
			return {lmNew = newModel, lmOrig = origModel, i = indices}
		else
			return {yHat = newModel["yHat"], i = indices}
		end
	end
	local n = #Y
	local mean = 0
	for _, coef in ipairs(Y) do
		mean = mean + coef[1]
	end
	mean = mean/n
	local meanMatrix = {}
	for i = 1, n do
		meanMatrix[i] = {mean}
	end
	if significantBTrack == nil then
		significantBTrack = {}
	end
	local k = #X[1] - 1 
	local df = n-k-1
	local Xt = module.matTranspose(X)
	local XtX = module.matMult(Xt, X)
	local XtXInv = module.matInverse(XtX)
	local XtY = module.matMult(Xt, Y)
	local b = module.matMult(XtXInv, XtY)
	if forward ~= true and mseCheck ~= true and diagnostics ~= true then
		return b
	end
	local yHat = module.matMult(X, b)
	local errors = module.matSubtract(Y, yHat)
	local SSE = 0
	for i = 1, n do
		SSE = SSE + errors[i][1]^2
	end
	if forward == true then
		return SSE, n, k
	end
	local MSE = SSE / df
	if mseCheck == true then
		return MSE
	end
	local total = module.matSubtract(Y, meanMatrix)
	local SST = 0
	for i = 1, n do
		SST = SST + total[i][1]^2
	end
	local MSR = ((SST - SSE) / k)
	local fStat = MSR / MSE
	local rSquared = 1 - (SSE / SST)
	local rSquaredAdj = 1 - ((1 - rSquared) * (n - 1)) / (n - k - 1)
	local s2b = module.scalarMatMult(MSE, XtXInv)
	local significantBIndices = {}
	local results = {}
	local allNonSignificant = true
	local tPValue = nil
	local tStatInfo = {}
	for i = 2, k + 1 do
		local variance = s2b[i][i]
		local stdErr = math.sqrt(variance)
		local tStat = b[i][1] / stdErr
		tPValue = 2 * (1 - tDistCDF(tStat, df))
		local isSignificant = alpha > tPValue
		table.insert(tStatInfo, {predictorIndex = i - 1, rejectH0 = isSignificant, t = tStat, pValue = tPValue})
	end
	table.insert(significantBTrack, significantBIndices)
	local pValueF
	if k < 2 then
		pValueF = tPValue
	else
		pValueF = fPValue(fStat, k, df)
	end
	if VIFs == true then
		return {yHat = b, r2 = rSquared, r2adj = rSquaredAdj, F = fStat, pValue = pValueF, BetaInfo = tStatInfo}
	else
		return {yHat = b, r2 = rSquared, r2adj = rSquaredAdj, F = fStat, pValue = pValueF, BetaInfo = tStatInfo}
	end
end

function module.predictY(X, model, yHat, indices)
	if yHat == nil then
		if model["lmNew"] == nil then
			yHat = model["yHat"]
		else
			yHat = model["lmNew"]["yHat"]
		end
	end
	if indices == nil then
		indices = model["i"]
	end
	local YPred = 0
	YPred = YPred + yHat[1][1]
	for i, idx in ipairs(indices) do
		YPred = YPred + X[idx] * yHat[i + 1][1]
	end
	return YPred
end

-- GENERATE RANDOM VARIABLES FROM DISTRIBUTIONS

function module.generateStandardNormal()
	local x = boxMuller()
	return x
end

function module.generateNormal(mu, sigma)
	local x = GenerateNormal(mu, sigma)
	return x
end

function module.generateGamma(alpha, beta)
	local x = GenerateGamma(alpha, beta)
	return x
end

function module.generateInverseGamma(alpha, beta)
	local x = GenerateGamma(alpha, beta)
	return 1/x
end

function module.generateUniform(a, b)
	return a + (b - a) * math.random()
end

function module.generateExponential(lambda)
	return -(math.log(1 - math.random()) / lambda)
end

function module.generateBeta(alpha, beta)
	local x = GenerateGamma(alpha, 1)
	local y = GenerateGamma(beta, 1)
	local result = x/(x+y)
	return result
end

function module.generateLogNormal(mu, sigma)
	return math.exp(mu + sigma * boxMuller())
end

function module.generateBetaPrime(alpha, beta)
	local y1 = GenerateGamma(alpha, 1)
	local y2 = GenerateGamma(beta, 1)
	return y1 / y2
end

function module.generateLevy(c, mu)
	return (c / ((math.sqrt(2) * InverseErrorFunction(2 * (1 - math.random / 2) - 1)) ^ 2)) + mu
end

function module.generatePoisson(lambda)
	local L = math.exp(-lambda)
	local k = 0
	local p = 1
	repeat
		k = k + 1
		p = p * math.random()
	until p <= L
	return k - 1
end

function module.generateCauchy(x0, gamma)
	return x0 + gamma * math.tan(math.pi * (math.random() - 0.5))
end

function module.generateWeibull(alpha, beta)
	local u = math.random()
	while u == 0 or u == 1 do
		u = math.random()
	end
	return alpha * (-math.log(1 - u))^(1 / beta)
end


function module.generateChiSquare(df)
	return module.generateGamma(df / 2, 0.5)
end

function module.generatePareto(alpha, xm)
	return xm * (1 - math.random())^(-1 / alpha)
end

function module.generateT(df)
	local x = module.generateStandardNormal()
	local y = module.generateChiSquare(df)
	return x / (math.sqrt(y / df))
end

-- GENERATE SCALED VARIABLES FROM DISTRIBUTIONS

function module.generateStandardNormalScaled(desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0.001
	end
	if UQpercent == nil then
		UQpercent = 0.999
	end

	if lowerQuantile == nil or upperQuantile == nil then
		lowerQuantile = cdfNormalInv(LQpercent, 1, 0)
		upperQuantile = cdfNormalInv(UQpercent, 1, 0)
	end
	local x = module.generateStandardNormal()
	local random = scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if random <= desiredMax and random >= desiredMin then
		return random
	else
		return module.generateStandardNormalScaled(desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end

function module.generateNormalScaled(mu, sigma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0.001
	end
	if UQpercent == nil then
		UQpercent = 0.999
	end
	if lowerQuantile == nil or upperQuantile == nil then
		lowerQuantile = cdfNormalInv(LQpercent, sigma, mu)
		upperQuantile = cdfNormalInv(UQpercent, sigma, mu)
	end
	local x = module.generateNormal(mu, sigma)
	local random = scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if random <= desiredMax and random >= desiredMin then
		return random
	else
		return module.generateNormalScaled(mu, sigma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end

function module.generateLogNormalScaled(mu, sigma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0
	end
	if UQpercent == nil then
		UQpercent = 0.999
	end

	if lowerQuantile == nil or upperQuantile == nil then
		lowerQuantile = LogInvCDF(LQpercent, mu, sigma)
		upperQuantile = LogInvCDF(UQpercent, mu, sigma)
	end
	local x = module.generateLogNormal(mu, sigma)
	local random = scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if random <= desiredMax and random >= desiredMin then
		return random
	else
		return module.generateLogNormalScaled(mu, sigma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end

function module.generateCauchyScaled(x0, gamma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0.001
	end
	if UQpercent == nil then
		UQpercent = 0.999
	end

	if lowerQuantile == nil or upperQuantile == nil then
		lowerQuantile = CauchyInvCDF(LQpercent, x0, gamma)
		upperQuantile = CauchyInvCDF(UQpercent, x0, gamma)
	end
	local x = module.generateCauchy(x0, gamma)
	local random = scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if random <= desiredMax and random >= desiredMin then
		return random
	else
		return module.generateCauchyScaled(x0, gamma, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end

function module.generateExponentialScaled(lambda, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0
	end
	if UQpercent == nil then
		UQpercent = 0.999
	end
	if lowerQuantile == nil or upperQuantile == nil then
		lowerQuantile = ExponentialInvCDF(LQpercent, lambda)
		upperQuantile = ExponentialInvCDF(UQpercent, lambda)
	end
	local x = module.generateExponential(lambda)
	local random = scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if random <= desiredMax and random >= desiredMin then
		return random
	else
		return module.generateExponentialScaled(lambda, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end

function module.generateGammaScaled(alpha, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0
	end
	if UQpercent == nil then
		UQpercent = 0.999
	end
	if LQpercent == 0 then 
		lowerQuantile = 0
		upperQuantile = GammaInvCDF(UQpercent, alpha, Gamma, lowerIncompleteGamma)
	end
	if (lowerQuantile == nil or upperQuantile == nil) and lowerQuantile ~= 0 then
		lowerQuantile = GammaInvCDF(LQpercent, alpha, Gamma, lowerIncompleteGamma)
		upperQuantile = GammaInvCDF(UQpercent, alpha, Gamma, lowerIncompleteGamma)
	end
	local x = module.generateGamma(alpha,1)
	local random = scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if random <= desiredMax and random >= desiredMin then
		return random
	else
		return module.generateGammaScaled(alpha, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end

function module.generateBetaScaled(alpha, beta, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0
	end
	if UQpercent == nil then
		UQpercent = 1
	end

	if lowerQuantile == nil or upperQuantile == nil then
		if LQpercent == 0 and UQpercent == 1 then
			lowerQuantile = 0
			upperQuantile = 1
		else
			lowerQuantile = BetaInverseCDF(LQpercent, alpha, beta)
			upperQuantile = BetaInverseCDF(UQpercent, alpha, beta)		
		end
	end
	local x = GenerateGamma(alpha, 1)
	local y = GenerateGamma(beta, 1)
	local result = x/(x+y)
	local scaledX = scaleToDesiredRange(result, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if scaledX >= desiredMin and scaledX <= desiredMax then
		return scaledX
	else
		return module.generateBetaScaled(alpha, beta, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end

-- GENERATE FROM CUSTOMIZED DISTRIBUTIONS

function module.customizedDistribution(piecewiseFunctions, desiredMin, desiredMax)
	local maxValue = findAbsoluteMaximum(piecewiseFunctions)
	local randomX, randomY, number, xMin, xMax, userFunctionString
	repeat
		local randomIndex = math.random(1, #piecewiseFunctions)
		userFunctionString, xMin, xMax = unpack(piecewiseFunctions[randomIndex])
		randomX, randomY = getRandomCoordinate(xMin, xMax, maxValue)
		number = evaluateUserFunction(userFunctionString, randomX)
	until randomY <= number
	randomX = desiredMin + (randomX - xMin) * (desiredMax - desiredMin) / (xMax - xMin)
	return randomX
end

-- GENERATE CONTINUOUS RANDOM VARIABLE FROM DATASET

function module.randomFromDataset(values, kernel, percentageOfFrameTime, bandwidth)
	local accuracy
	if percentageOfFrameTime == nil then
		percentageOfFrameTime = 0.1
	end
	local sigma = StandardDeviation(values)
	local n = #values
	local m
	if sigma == 0 then
		return values[1]
	else
		m = math.min(sigma,(InterquartileRange(values) / 1.349)) -- IQR/1.349 is the F-Pseudosigma
		bandwidth = bandwidth or (0.9 * m) / n ^ (1 / 5)
	end
	if sigma == 0 then
		sigma = 1
	end
	local range = Range(values)
	local predictedTime = n * range * 0.00000001141 + (range) ^ 0.5 * 0.00006098 + 0.000001761 * n + 0.0000000125 * range
	local intervalFraction = (predictedTime*1.5)/(percentageOfFrameTime/60)
	local interval = intervalFraction
	local minX = math.min(unpack(values))
	local maxX = math.max(unpack(values))
	local maxY = 0
	local startTime = tick()
	for x = minX, maxX, interval * 4 do
		local density = kernelDensityEstimation(values, bandwidth, x, n, kernel)
		if density > maxY then
			maxY = density
		end
	end
	local finishTime = tick()
	local timeElapsed = finishTime - startTime
	local threshold = 0.0025 * maxY * percentageOfFrameTime 
	local lowerBound = minX
	local startTime1 = tick()
	while true do
		local density = kernelDensityEstimation(values, bandwidth, lowerBound, n, kernel)
		if density < threshold then 
			break 
		end
		lowerBound = lowerBound - interval
	end
	local upperBound = maxX
	while true do
		local density = kernelDensityEstimation(values, bandwidth, upperBound, n, kernel)
		if density < threshold then 
			break 
		end
		upperBound = upperBound + interval
	end
	local finishTime1 = tick()
	local timeElapsed1 = finishTime1 - startTime1
	local startTime2 = tick()
	while true do
		local xRandom = math.random() * (upperBound - lowerBound) + lowerBound
		local y = kernelDensityEstimation(values, bandwidth, xRandom, n, kernel)
		local yRandom = math.random() * maxY
		if yRandom <= y then
			local finishTime2 = tick()
			local timeElapsed2 = finishTime2 - startTime2
			return xRandom
		end
	end
end

-- MARKOV CHAIN

function module.markovChain(states, transitionProbs, startState, length, returnFullSequence)
	local sequence = {startState}
	local currentState = startState
	for i = 2, length do
		currentState = chooseNextState(currentState, transitionProbs)
		table.insert(sequence, currentState)
	end
	if returnFullSequence then
		return sequence
	else
		return sequence[length]
	end
end

return module



--Future Update: LASSO Regression and Stepwise Selection

--[[local function lassoRegression(X, Y, lambda, learningRate, epochs)
	local n = #Y
	local k = #X[1]
	local b = {}
	for i = 1, k do
		table.insert(b, {0})
	end
	for epoch = 1, epochs do
		local YHat = module.matMult(X, b)
		local errors = module.matSubtract(Y, YHat)
		local gradient = module.matMult(module.matTranspose(X), errors)
		for i = 1, k do -- l1
			if b[i][1] > 0 then
				gradient[i][1] = gradient[i][1] - lambda
			elseif b[i][1] < 0 then
				gradient[i][1] = gradient[i][1] + lambda
			end
			b[i][1] = b[i][1] + learningRate * gradient[i][1]
		end
	end
	return b
end

local function calculateRMSE(predicted, actual)
	local sum = 0
	local n = #actual
	for i = 1, n do
		sum = sum + (predicted[i][1] - actual[i][1]) ^ 2
	end
	return math.sqrt(sum / n)
end

function trainModel(trainX, trainY, lambda, learningRate, epochs)
	return lassoRegression(trainX, trainY, lambda, learningRate, epochs)
end

function predict(model, X)
	return module.matMult(X, model)
end

local function splitData(X, Y, ratio)
	local trainX = {}
	local trainY = {}
	local validationX = {}
	local validationY = {}
	local n = #Y
	local Indices = {}
	for i = 1, n do
		table.insert(Indices, i)
	end
	for i = n, 2, -1 do
		local j = math.random(i)
		Indices[i], Indices[j] = Indices[j], Indices[i]
	end
	local trainSize = math.floor(ratio * n)
	for i = 1, trainSize do
		local index = Indices[i]
		table.insert(trainX, X[index])
		table.insert(trainY, Y[index])
	end
	for i = trainSize + 1, n do
		local index = Indices[i]
		table.insert(validationX, X[index])
		table.insert(validationY, Y[index])
	end
	return trainX, trainY, validationX, validationY
end


local function gridSearch(trainX, trainY, validationX, validationY)
	local lambdas = {0.00001, 0.01, 0.1, 1}
	local learningRates = {0.00001, 0.01, 0.1}
	local epochsList = {100, 500,1000}
	local bestLambda, bestLearningRate, bestEpochs
	local bestRMSE = math.huge
	for _, lambda in ipairs(lambdas) do
		for _, learningRate in ipairs(learningRates) do
			for _, epochs in ipairs(epochsList) do
				local model = trainModel(trainX, trainY, lambda, learningRate, epochs)
				local predicted = predict(model, validationX)
				local rmse = calculateRMSE(predicted, validationY)
				if rmse < bestRMSE then
					bestRMSE = rmse
					bestLambda = lambda
					bestLearningRate = learningRate
					bestEpochs = epochs
				end
			end
		end
	end
end

function module.lassoRegression(X, Y, ratio)
	if ratio == nil then
		ratio = 0.5
	end
	local trainX, trainY, validationX, validationY = splitData(X, Y, ratio)
	local bestLambda, bestLearningRate, bestEpochs = gridSearch(trainX, trainY, validationX, validationY)
	local bestModel = trainModel(trainX, trainY, bestLambda, bestLearningRate, bestEpochs)
	local predicted = predict(bestModel, validationX)
	local rmse = calculateRMSE(predicted, validationY)
end

function lassoPenalty(lambda, w)
	local sum = 0
	for i = 1, #w do
		sum = sum + math.abs(w[i][1])
	end
	return lambda * sum
end

function lassoCalculateCost(m, w, y, yPred, lambda)
	local sum = 0
	for i = 1, m do
		sum = sum + (yPred[i][1] - y[i][1]) ^ 2
	end
	return (sum / (2 * m)) + lassoPenalty(lambda, w)
end

function lassoFit(X, y, lambda, lr, epochs)
	local m = #y
	local n = #X[1]
	local w = {}
	for i = 1, n do
		table.insert(w, {0})
	end
	for epoch = 1, epochs do
		local yPred = module.matMult(X, w)
		local cost = lassoCalculateCost(m, w, y, yPred, lambda)
		local errors = module.matSubtract(y, yPred)
		local gradient = module.matMult(module.matTranspose(X), errors)
		local derivative = {}
		for i = 1, #w do
			table.insert(derivative, {lambda * (w[i][1] > 0 and 1 or -1)})
		end
		for i = 1, n do
			gradient[i][1] = gradient[i][1] + derivative[i][1]
			w[i][1] = w[i][1] - lr * gradient[i][1]
		end
		if epoch % 100 == 0 then
		end
	end
	return w
end

function lassoPredict(XTest, w)
	return module.matMult(XTest, w)
end

local function findMin(arr)
	local minValue = nil
	local minIndex = nil
	for i, v in ipairs(arr) do
		if minValue == nil or v < minValue then
			minValue = v
			minIndex = i
		end
	end
	return minValue, minIndex
end

local function findMax(arr)
	local maxValue = nil
	local maxIndex = nil
	for i, v in pairs(arr) do
		if maxValue == nil or v > maxValue then
			maxValue = v
			maxIndex = i
		end
	end
	return maxValue, maxIndex
end

local function stepwiseRegression(X, Y, alpha)
	local currentModel = {}
	local remainingPredictors = {}
	for i = 1, #X[1] do
		remainingPredictors[i] = i
	end
	while true do
		local minPvalueIn, minIndexIn = 1, nil
		local maxPvalueOut, maxIndexOut = 0, nil
		-- forward
		for _, predictor in ipairs(remainingPredictors) do
			local predictorSubset = {}
			for k, _ in pairs(currentModel) do
				table.insert(predictorSubset, k)
			end
			table.insert(predictorSubset, predictor)
			local subset = extractColumns(X, predictorSubset, nil, true)
			local pvalue = module.multipleLinearRegression(subset, Y, 1 - alpha, false, nil, nil, nil, false, nil, true)
			if pvalue < minPvalueIn then
				minPvalueIn = pvalue
				minIndexIn = predictor
			end
		end
		if minPvalueIn < alpha then
			currentModel[minIndexIn] = true
			for i, predictor in ipairs(remainingPredictors) do
				if predictor == minIndexIn then
					table.remove(remainingPredictors, i)
					break
				end
			end
		end
		-- backward
		for predictor, _ in pairs(currentModel) do 
			local predictorSubset = {}
			for k, _ in pairs(currentModel) do
				table.insert(predictorSubset, k)
			end
			local subset = extractColumns(X, predictorSubset, nil, true)
			local pvalue = module.multipleLinearRegression(subset, Y, 1 - alpha, false, nil, nil, nil, false, nil, true)
			if pvalue > maxPvalueOut then
				maxPvalueOut = pvalue
				maxIndexOut = predictor
			end
		end
		if maxPvalueOut > alpha then
			currentModel[maxIndexOut] = nil
			table.insert(remainingPredictors, maxIndexOut)
		end
		if minPvalueIn >= alpha and maxPvalueOut <= alpha then
			break
		end
	end
	return currentModel
end]]

-- needs work on levy quantile function
--[[function module.generateLevyScaled(c, mu, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	if LQpercent == nil then
		LQpercent = 0
	end
	if UQpercent == nil then
		UQpercent = 0.999
	end

	if lowerQuantile == nil or upperQuantile == nil then
		local lowerQuantile = levyInvCDF(LQpercent, c) -- the quantile function for the levy distribution is awful to work with
		local upperQuantile = levyInvCDF(UQpercent, c)
	end
	local x = module.generateLevy(c)
	local random = scaleToDesiredRange(x, lowerQuantile, upperQuantile, desiredMin, desiredMax)
	if random <= desiredMax and random >= desiredMin then
		return random
	else
		return module.generateLevyScaled(c, desiredMin, desiredMax, LQpercent, UQpercent, lowerQuantile, upperQuantile)
	end
end]]
