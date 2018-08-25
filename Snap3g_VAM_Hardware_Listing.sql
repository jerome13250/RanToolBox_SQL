--CREATE EXTENSION tablefunc;

DROP TABLE IF EXISTS t_vam_hardware_list;
CREATE TABLE t_vam_hardware_list AS

SELECT *
FROM crosstab ($$
	SELECT 
	  snap3g_board.btsequipment,
	  'TRDU60' AS boardtype,
	  count(snap3g_board.btsequipment) AS boardtype
	FROM 
	  public.snap3g_board
	WHERE
	  snap3g_board.moduletype = '111' --TRDU BAND01 4C 60W 
	GROUP BY
	  snap3g_board.btsequipment

	UNION

	SELECT 
	  snap3g_board.btsequipment,
	  'TWINRRH' AS boardtype,
	  count(snap3g_board.btsequipment) AS boardtype
	FROM 
	  public.snap3g_board
	WHERE
	  snap3g_board.moduletype IN ('98','112')  --RRH
	GROUP BY
	  snap3g_board.btsequipment

	UNION

	SELECT 
	  snap3g_board.btsequipment,
	  'ECEM' AS boardtype,
	  count(snap3g_board.btsequipment) AS boardtype
	FROM 
	  public.snap3g_board
	WHERE
	  snap3g_board.moduletype = '86' AND
	  snap3g_board.modulesubtype = '3'
	GROUP BY
	  snap3g_board.btsequipment


	UNION

	SELECT 
	  snap3g_board.btsequipment,
	  'ECEM-U' AS boardtype,
	  count(snap3g_board.btsequipment) AS boardtype
	FROM 
	  public.snap3g_board
	WHERE
	  snap3g_board.moduletype = '86' AND
	  snap3g_board.modulesubtype = '2'
	GROUP BY
	  snap3g_board.btsequipment

	ORDER BY 1,2 $$ 
	, $$VALUES ( 'TRDU60') ,('TWINRRH') ,( 'ECEM'),('ECEM-U')$$

	)

AS final_result(
	btsequipment TEXT,
	"TRDU60" INTEGER,
	 "TWINRRH" INTEGER,
	 "ECEM" INTEGER,
	 "ECEM-U" INTEGER
	 )
;


