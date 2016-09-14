import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class DomActorParser {
	Document dom;

	HashMap<String, ArrayList<String>> ActorStageToReal = new HashMap<String, ArrayList<String>>();
	
	public DomActorParser(){
	}

	public void runExample() {
		parseCasts();
		parseDocument();	
	}

	private void parseCasts(){
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();	
		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			dom = db.parse("actors63.xml");
			
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(IOException ioe) {
			ioe.printStackTrace();
		}
	}
	
	private void parseDocument(){
		Element docEle = dom.getDocumentElement();
		createActorsFakeToActorsReal(docEle);
	}
	
	private void createActorsFakeToActorsReal(Element docEle){
		NodeList mList = docEle.getElementsByTagName("actor");

		for(int i = 0; i < mList.getLength();i++){
			String actorRealFirst = "";
			String actorRealLast= "";
			String actorStageName = "";
			String dob = "";
			Node currentN = mList.item(i);
			int flag = 1;
			if(currentN.getNodeType() == Node.ELEMENT_NODE){
				Element currentE = (Element) currentN;
				actorStageName =  currentE.getElementsByTagName("stagename").item(0).getTextContent();
				actorRealFirst = currentE.getElementsByTagName("firstname").item(0).getTextContent();
				try{
				dob =currentE.getElementsByTagName("dob").item(0).getTextContent();
				}
				catch(Exception e){}
				try{
				actorRealLast = currentE.getElementsByTagName("familyname").item(0).getTextContent();
				}
				catch(Exception e){
					flag = 0;
				}
			}
			if(actorRealFirst != "" & actorRealLast != ""){
				if(flag ==1){
					ArrayList<String> actorReal = new ArrayList<String>();
					actorReal.add(actorRealFirst);
					actorReal.add(actorRealLast);
					actorReal.add(dob);
					ActorStageToReal.put(actorStageName,actorReal);
				}
			}
		}
		/*for(String stageName : ActorStageToReal.keySet()){
			System.out.println(stageName + ":" + ActorStageToReal.get(stageName).get(0) + " " + ActorStageToReal.get(stageName).get(1));
		}*/
	}
	
}