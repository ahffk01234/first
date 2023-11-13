package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.Board;
import kr.or.ddit.vo.SearchVO;

public interface IBoardService {
	public void register(Board board);
	public List<Board> list();
	public Board read(int boardNo) throws Exception;
	public void modify(Board board);
	public void delete(int boardNo);
	public List<Board> search(Board board);
	public List<Board> searchBoard(SearchVO board);
}
