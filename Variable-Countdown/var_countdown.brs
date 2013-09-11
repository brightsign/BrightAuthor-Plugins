
Sub countdown(xmlFileName$ as String, itemsByIndex as object, itemsByTitle as Object, userVariables As Object)
	currentvalue=99
		if userVariables.DoesExist("countdown") then
			myvariable = userVariables.Lookup("countdown")
			if myvariable <> invalid then 
				currentvalue = int(val(myvariable.GetCurrentValue()))
				if currentvalue > 0 then currentvalue = currentvalue-1
				myvariable.SetCurrentValue(str(currentvalue),true)
			endif
		endif
end Sub
