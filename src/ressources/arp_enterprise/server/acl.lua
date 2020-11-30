function AlterCanOpenSafe(Alter, enterprise)
	if (Alter.job.GetEnterprise() == enterprise and Alter.job.GetGrade() > 1) then
		return (true)
	end
	return (false)
end