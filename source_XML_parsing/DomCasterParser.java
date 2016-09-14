import java.io.IOException;
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

public class DomCasterParser {

	//No generics
	Document dom;

	HashMap<String,Set<String>> ActorMoviesDict = new HashMap<String, Set<String>>();
	
	public DomCasterParser(){
	}

	public void runExample() {
		parseCasts();
		parseDocument();	
		//printActorMoviesDict();
	}
	public HashMap<String,Set<String>> getActorMoviesDict(){
		return ActorMoviesDict;
	}
	
	private void parseCasts(){
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();	
		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			dom = db.parse("casts124.xml");
			
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
		createActorsMoviesDict(docEle);
		
	}
	private void createActorsMoviesDict(Element docEle){
		NodeList mList = docEle.getElementsByTagName("m");

		for(int i = 0; i < mList.getLength();i++){
			String actor;
			String title;
			Node currentN = mList.item(i);
			if(currentN.getNodeType() == Node.ELEMENT_NODE){
				Element currentE = (Element) currentN;
				actor =  currentE.getElementsByTagName("a").item(0).getTextContent();
				title =  currentE.getElementsByTagName("t").item(0).getTextContent().replaceAll("[^a-zA-Z\\s]", "").replaceAll("\\s+", " ");
				if(ActorMoviesDict.containsKey(actor)){
					ActorMoviesDict.get(actor).add(title);
				}
				else{
					Set<String> initTitleList = new HashSet<String>();
					initTitleList.add(title);
					ActorMoviesDict.put(actor,initTitleList);

				}
			}
		}
	}


	public void printActorMoviesDict(){
		for(String key: ActorMoviesDict.keySet() ){
			System.out.printf(key + " : " + ActorMoviesDict.get(key) + "\n");
		}
	}



	
}
