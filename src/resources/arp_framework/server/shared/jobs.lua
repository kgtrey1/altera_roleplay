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

ARP.Jobs.GetJobLabel = function(jobName)
    if (ARP.Jobs.List[jobName] ~= nil) then
        return (ARP.Jobs.List[jobName].label)
    end
end

ARP.Jobs.IsJobWhitelisted = function(jobName)
    if (ARP.Jobs.List[jobName] ~= nil) then
        return (ARP.Jobs.List[jobName].whitelisted)
    end
end

ARP.Jobs.GetBossGrade = function(jobName)
    for k, v in pairs(ARP.Jobs.List[jobName].grades) do
        if (v.name == "boss") then
            return (v.grade)
        end
    end
end