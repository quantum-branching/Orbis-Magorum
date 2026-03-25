##Allows additional math this there is no operator or function available for.
extends Node

#region Array Math
##Returns an array that is the product of the two input arrays.[br][br][b]Example:[/b][codeblock]print(ArrayMultiply([1,2,3,4,5],[5,4,3,2,1])) #Returns [5,8,9,8,5][/codeblock]
func ArrayMultiply(Array1:Array,Array2:Array) -> Array:
	var length = len(Array1)
	var ResultArray = []
	for i in range(length):
		if Array1[i] is int or Array1[i] is float:
			if Array2[i] is int or Array2[i] is float:
				ResultArray.append((Array1[i])*(Array2[i]))
			else:
				ResultArray.append(0)
		else:
			ResultArray.append(0)
	return ResultArray

##Returns mean or average value of the input array.[br][br][b]Example:[/b][codeblock]print(mean([1,2,3,4,5,6,7])) #Returns 4[/codeblock]
func mean(Numbers:Array) -> float:
	median()
	if len(Numbers) > 0:
		return sum(Numbers)/len(Numbers)
	else:
		return 0

##This function returns the median value of the input array. The median is a the middle most value of a sorted list. All values in the input array must be either a float or an int. [br][br][b]Example: [/b][codeblock]var list:Array[float] = [27,6,11,3,18]
##print(median(list)) #Returns 11
##list.sort()
##print(list[3]) #Returns 11
##[/codeblock]
func median(Numbers:Array[float] = []) -> float:
	var Num2:Array[float] = Numbers.duplicate()
	Num2.sort()
	var NumIndex:float = len(Numbers)/2.0
	var Result:float
	if not int(NumIndex) == NumIndex:
		Result = (Num2[NumIndex-1.5] + Num2[NumIndex-.5])/2
	else:
		Result = Num2[NumIndex-1]
	return Result

##Returns the sum of the input array.[br][br][b]Example:[/b][codeblock]print(sum([1,2,3,4,5,6,7])) #Returns 28[/codeblock]
func sum(Numbers:Array = []) -> float:
	var Sum = 0
	var length = len(Numbers)
	for index in range(length):
		if Numbers[index-1]:
			Sum = Sum + float(Numbers[index-1])
	return Sum



#endregion

#region Formating

func NumToText(Number:float):
	var length:int = 0
	if abs(Number) > 0:
		length = 1+int(log(abs(Number))/log(10))
	var NumText = ""
	var Num:int = int(Number)
	for i in length:
		if i%3 == 0 and not i == 0:
			NumText = "".join([",",NumText])
		NumText = "".join([Num%10,NumText])
		Num = int(Num/10.0)
	return NumText

#endregion

#region Vector Math

##Returns the distance between two [Vector2] variables.[br][br][b]Example:[/b][codeblock]var Distance:float = Vector2Distance(Vec1:Vector2,Vec2:Vector2)[/codeblock]
func Vector2Distance(Vec1:Vector2,Vec2:Vector2) -> float:
	return sqrt(((Vec1.x-Vec2.x)**2)+((Vec1.y-Vec2.y)**2))

##Returns the distance between two [Vector3] variables.[br][br][b]Example:[/b][codeblock]var Distance:float = Vector3Distance(Vec1:Vector3,Vec2:Vector3)[/codeblock]
func Vector3Distance(Vec1:Vector3,Vec2:Vector3):
	return sqrt(((Vec1.x-Vec2.x)**2)+((Vec1.y-Vec2.y)**2)+((Vec1.z-Vec2.z)**2))
#endregion
