#!/usr/bin/awk -f


function fill(key, value){
	value = 0 + value
	total[key] += value
	if (minArr[key] == "" || minArr[key] > value) {
		minArr[key] = value
	}
	if (maxArr[key] == "" || maxArr[key] < value){
		maxArr[key] = value
	}
}

BEGIN { 
	FS=";" 
	
	mapping["M"]="memory"
	mapping["W"]="swapped"
	mapping["P"]="majorPageFaults"
	mapping["S"]="systemCPU"
	mapping["U"]="userCPU"
	mapping["A"]="allCPU"
	mapping["C"]="cpuPercent"
	mapping["T"]="realTime"
	mapping["I"]="inputs"
	mapping["O"]="outputs"
	count=0
} 
{
	count+=1
	
	fill("memory", $1)
	fill("swapped", $2)
	fill("majorPageFaults", $3)
	fill("systemCPU", $4)
	fill("userCPU", $5)
	fill("allCPU", $4+$5)
	fill("cpuPercent", $6)
	fill("realTime", $7)
	fill("inputs", $8)
	fill("outputs", $9)

}
END{
	printFormat=FORMAT
	for(short in mapping){
		key = mapping[short]
		avgKey="%avg"short
		minKey="%min"short
		maxKey="%max"short
		gsub(minKey, minArr[key],printFormat)
		gsub(maxKey, maxArr[key],printFormat)
		gsub(avgKey, total[key]/count,printFormat)
	}
	print printFormat
} 