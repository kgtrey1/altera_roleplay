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
    for i = 1, #ARP.Jobs.List[jobName].grades, 1 do
        if (ARP.Jobs.List[jobName].grades[i].name == "boss") then
            return (ARP.Jobs.List[jobName].grades[i].rank)
        end
    end
end