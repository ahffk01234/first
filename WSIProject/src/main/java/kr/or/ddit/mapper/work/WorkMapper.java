package kr.or.ddit.mapper.work;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.PaginationInfoVO;
import kr.or.ddit.vo.VacationPersonalVO;
import kr.or.ddit.vo.WorkVO;

public interface WorkMapper {

	public String adminCheck(String empNo);

	public List<EmpVO> empList();

	public List<WorkVO> workList(HashMap<String, String> workMap);

	public List<WorkVO> teamWorkList(HashMap<String, String> map);

	public List<WorkVO> workManageList(HashMap<String, String> map);

	public List<WorkVO> selectWork(HashMap<String, String> workMap);

	public List<WorkVO> workApplyList(HashMap<String, String> map);

	public List<WorkVO> workManagement(HashMap<String, String> map);

	public int selectTeamWorkCount(PaginationInfoVO<WorkVO> pagingVO);

	public List<WorkVO> selectTeamWorkList(PaginationInfoVO<WorkVO> pagingVO);

	public int selectWorkManageCount(PaginationInfoVO<WorkVO> pagingVO);

	public List<WorkVO> selectWorkManageList(PaginationInfoVO<WorkVO> pagingVO);

	public int insertworkStart(String empNo);

	public WorkVO selectoneWork(String empNo);

	public int updateworkEnd(String empNo);

	public int updateworkTotal(WorkVO workVO);

	public List<WorkVO> workListMonth(HashMap<String, String> workMap);

}
