--
-- ALTERA PROJECT, 2020
-- ARP_Framework
-- File description:
-- Object related to jobs.
--

ARP.Jobs = {}
ARP.Jobs.List = {}

ARP.Jobs.GetJob = function(jobname)
    if (ARP.Jobs.List[jobname] ~= nil) then
        return (ARP.Jobs.List[jobname])
    end
    return (nil)
end

ARP.Jobs.GetGradeData = function(jobname, grade)
    if (ARP.Jobs.List[jobname] ~= nil and ARP.Jobs.List[jobname].grades[grade]) then
        return (ARP.Jobs.List[jobname].grades[grade])
    end
    return (nil)
end