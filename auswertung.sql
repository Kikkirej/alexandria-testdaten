SELECT
	unnest(ARRAY ['Anzahl Projekte', 'Anzahl Versionen', 'Anzahl Dockerfiles', 'Anzahl Docker Images', 'Anzahl Maven Dependencies', 'Anzahl NodeJS Dependencies']) AS "Metriken",
	unnest(ARRAY [
   		(SELECT count(p.*) FROM project p LEFT JOIN source s ON p.source_id = s.id WHERE type = 'GitHub'),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id WHERE type = 'GitHub' ),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id LEFT JOIN analysis a ON v.latest_analysis_id = a.id LEFT JOIN docker_file df ON df.analysis_id = a.id WHERE type = 'GitHub' ),
   		(SELECT COUNT(*) FROM(SELECT di."name", dif.tag FROM docker_image di
   						LEFT JOIN docker_image_file dif ON di.id = dif.docker_image_id
   						LEFT JOIN docker_file df ON df.id = dif.docker_file_id
   						LEFT JOIN analysis a ON a.id = df.analysis_id
   						LEFT JOIN "version" v ON a.version_id = version_id
   						LEFT JOIN project p ON p.id = v.project_id
   						LEFT JOIN "source" s ON s.id = p.source_id
   WHERE s."type" = 'GitHub'
   GROUP BY di."name", dif.tag) AS "count"),
   (SELECT COUNT(*) FROM(
      SELECT DISTINCT mmd.scope, mmd.version, md.group_id, md.artifact_id, mmd.packaging FROM maven_dependency md
          LEFT JOIN maven_module_dependency mmd on md.id = mmd.dependency_id
          LEFT JOIN maven_module mm on mmd.module_id = mm.id
          LEFT JOIN analysis a ON a.id = mm.analysis_id
          LEFT JOIN "version" v ON a.version_id = version_id
          LEFT JOIN project p ON p.id = v.project_id
          LEFT JOIN "source" s ON s.id = p.source_id
      WHERE s."type" = 'GitHub' and mmd.scope is not null
      ) AS "count"),
      (SELECT COUNT(*) FROM(SELECT nd."name", npd."version" FROM npm_dependency nd
 						LEFT JOIN npm_project_dependency npd ON nd.id = npd.dependency_id
 						LEFT JOIN npm_project np ON npd.project_id = np.id
  						LEFT JOIN analysis a ON np.analysis_id = a.id
  						LEFT JOIN "version" v ON a.version_id = v.id
  						LEFT JOIN project p ON p.id = v.project_id
  						LEFT JOIN "source" s ON s.id = p.source_id
 WHERE s."type" = 'GitHub'
 GROUP BY nd."name", npd."version") AS "count")
   	]) AS "GitHub",
	unnest(ARRAY [
   		(SELECT count(p.*) FROM project p LEFT JOIN source s ON p.source_id = s.id WHERE type = 'GitLab'),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id WHERE type = 'GitLab' ),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id LEFT JOIN analysis a ON v.latest_analysis_id = a.id LEFT JOIN docker_file df ON df.analysis_id = a.id WHERE type = 'GitLab' ),
   		(SELECT COUNT(*) FROM(SELECT di."name", dif.tag FROM docker_image di
   						LEFT JOIN docker_image_file dif ON di.id = dif.docker_image_id
   						LEFT JOIN docker_file df ON df.id = dif.docker_file_id
   						LEFT JOIN analysis a ON a.id = df.analysis_id
   						LEFT JOIN "version" v ON a.version_id = version_id
   						LEFT JOIN project p ON p.id = v.project_id
   						LEFT JOIN "source" s ON s.id = p.source_id
   WHERE s."type" = 'GitLab'
   GROUP BY di."name", dif.tag) AS "count"),
   (SELECT COUNT(*) FROM(
     SELECT DISTINCT mmd.scope, mmd.version, md.group_id, md.artifact_id, mmd.packaging FROM maven_dependency md
         LEFT JOIN maven_module_dependency mmd on md.id = mmd.dependency_id
         LEFT JOIN maven_module mm on mmd.module_id = mm.id
         LEFT JOIN analysis a ON a.id = mm.analysis_id
         LEFT JOIN "version" v ON a.version_id = version_id
         LEFT JOIN project p ON p.id = v.project_id
         LEFT JOIN "source" s ON s.id = p.source_id
     WHERE s."type" = 'GitLab' and mmd.scope is not null
     ) AS "count"),
     (SELECT COUNT(*) FROM(SELECT nd."name", npd."version" FROM npm_dependency nd
 						LEFT JOIN npm_project_dependency npd ON nd.id = npd.dependency_id
 						LEFT JOIN npm_project np ON npd.project_id = np.id
  						LEFT JOIN analysis a ON np.analysis_id = a.id
  						LEFT JOIN "version" v ON a.version_id = v.id
  						LEFT JOIN project p ON p.id = v.project_id
  						LEFT JOIN "source" s ON s.id = p.source_id
 WHERE s."type" = 'GitLab'
 GROUP BY nd."name", npd."version") AS "count")
   	]) AS "GitLab",
	unnest(ARRAY [
   		(SELECT count(p.*) FROM project p LEFT JOIN source s ON p.source_id = s.id WHERE type = 'Filesystem'),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id WHERE type = 'Filesystem' ),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id LEFT JOIN analysis a ON v.latest_analysis_id = a.id LEFT JOIN docker_file df ON df.analysis_id = a.id WHERE type = 'Filesystem' ),
   		(SELECT COUNT(*) FROM(SELECT di."name", dif.tag FROM docker_image di
   						LEFT JOIN docker_image_file dif ON di.id = dif.docker_image_id
   						LEFT JOIN docker_file df ON df.id = dif.docker_file_id
   						LEFT JOIN analysis a ON a.id = df.analysis_id
   						LEFT JOIN "version" v ON a.version_id = version_id
   						LEFT JOIN project p ON p.id = v.project_id
   						LEFT JOIN "source" s ON s.id = p.source_id
   WHERE s."type" = 'Filesystem'
   GROUP BY di."name", dif.tag) AS "count"),
   (SELECT COUNT(*) FROM(
     SELECT DISTINCT mmd.scope, mmd.version, md.group_id, md.artifact_id, mmd.packaging FROM maven_dependency md
         LEFT JOIN maven_module_dependency mmd on md.id = mmd.dependency_id
         LEFT JOIN maven_module mm on mmd.module_id = mm.id
         LEFT JOIN analysis a ON a.id = mm.analysis_id
         LEFT JOIN "version" v ON a.version_id = version_id
         LEFT JOIN project p ON p.id = v.project_id
         LEFT JOIN "source" s ON s.id = p.source_id
     WHERE s."type" = 'Filesystem' and mmd.scope is not null
     ) AS "count"),
     (SELECT COUNT(*) FROM(SELECT nd."name", npd."version" FROM npm_dependency nd
 						LEFT JOIN npm_project_dependency npd ON nd.id = npd.dependency_id
 						LEFT JOIN npm_project np ON npd.project_id = np.id
  						LEFT JOIN analysis a ON np.analysis_id = a.id
  						LEFT JOIN "version" v ON a.version_id = v.id
  						LEFT JOIN project p ON p.id = v.project_id
  						LEFT JOIN "source" s ON s.id = p.source_id
 WHERE s."type" = 'Filesystem'
 GROUP BY nd."name", npd."version") AS "count")
   	]) AS "Dateisystem",
	unnest(ARRAY [
   		(SELECT count(p.*) FROM project p),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id),
   		(SELECT count(*) FROM project p LEFT JOIN source s ON p.source_id = s.id LEFT JOIN version v ON p.id = v.project_id LEFT JOIN analysis a ON v.latest_analysis_id = a.id LEFT JOIN docker_file df ON df.analysis_id = a.id),
   		(SELECT COUNT(*) FROM(SELECT di."name", dif.tag FROM docker_image di
   						LEFT JOIN docker_image_file dif ON di.id = dif.docker_image_id
   						LEFT JOIN docker_file df ON df.id = dif.docker_file_id
   						LEFT JOIN analysis a ON a.id = df.analysis_id
   						LEFT JOIN "version" v ON a.version_id = version_id
   						LEFT JOIN project p ON p.id = v.project_id
   						LEFT JOIN "source" s ON s.id = p.source_id
   GROUP BY di."name", dif.tag) AS "count"),
   (SELECT COUNT(*) FROM(
     SELECT DISTINCT mmd.scope, mmd.version, md.group_id, md.artifact_id, mmd.packaging FROM maven_dependency md
         LEFT JOIN maven_module_dependency mmd on md.id = mmd.dependency_id
         LEFT JOIN maven_module mm on mmd.module_id = mm.id
         LEFT JOIN analysis a ON a.id = mm.analysis_id
         LEFT JOIN "version" v ON a.version_id = version_id
         LEFT JOIN project p ON p.id = v.project_id
         LEFT JOIN "source" s ON s.id = p.source_id
     WHERE mmd.scope is not null
     ) AS "count"),
     (SELECT COUNT(*) FROM(SELECT nd."name", npd."version" FROM npm_dependency nd
 						LEFT JOIN npm_project_dependency npd ON nd.id = npd.dependency_id
 						LEFT JOIN npm_project np ON npd.project_id = np.id
  						LEFT JOIN analysis a ON np.analysis_id = a.id
  						LEFT JOIN "version" v ON a.version_id = v.id
  						LEFT JOIN project p ON p.id = v.project_id
  						LEFT JOIN "source" s ON s.id = p.source_id
 GROUP BY nd."name", npd."version") AS "count")
   	]) AS "Kombiniert";


