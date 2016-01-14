const const_resoult={en:["Big","Small","Odd","Even","1st Dozen","2nd Dozen","3rd Dozen","19-36","1-18"],
					ch:["大","小","单","双","第一打","第二打","第三打","19-36","1-18"],
					tw:["大","小","單","雙","第一打","第二打","第三打","19-36","1-18"]}
function GetResoultList(lang="ch"):Array{
	var resoultlist:Array=const_resoult[lang]
	if(resoultlist==null){
		resoultlist=const_resoult["en"]
	}
	return resoultlist
}
