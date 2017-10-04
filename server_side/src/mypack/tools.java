package mypack;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.Provider;
import java.security.Security;

import org.bouncycastle.jce.provider.BouncyCastleProvider;


public class tools {
   // final static String dlk = "FABE3EA9CA4EA7D0AE3BC7AF220B86BF";
   // private String seslk = "";
    
    private String mString = "";

	private String iccBalance = "";
	private String tranSequence = "";
	private String iccRandom = "";
	private String iccMac1 = "";
	private String terminalNum = "112233445566";
	private String transactionId = "02";
	private String money = "00000000";
	private String mac1Src = "";
	private String mac2Src = "";
	private String seslk = "";
	private String random = "";
	
	final static String dlk = "FABE3EA9CA4EA7D0AE3BC7AF220B86BF";
	final static String dpk = "EC7D409E75101DB6F17C74C557BF301E";
	
    
    
    

    String byte2string(byte[] b){
        //StringBuilder sb = new StringBuilder(b.length);
        String temp = "";
        //for(byte by : b)
           // sb.append(String.format("%20X",by));
        for(int i =0;i<b.length;i++){
        	// sb.append(String.format("%20X",b[i]));
        	temp += b[i];
        }

        return temp;
    }

    public String enc3Des(String data) {
        byte[] dataBytes = HexString2Bytes(data);
        byte[] dlkBytes = HexString2Bytes(dlk);
        byte[] key24Bytes = new byte[24];
        byte[] encDataBytes = data.getBytes();

        try {

            Security.addProvider(new BouncyCastleProvider());
            String Algorithm = "DESede/ECB/NoPadding";

            System.arraycopy(dlkBytes, 0, key24Bytes, 0, 16);
            System.arraycopy(dlkBytes, 0, key24Bytes, 16, 8);
            SecretKey deskey = new SecretKeySpec(key24Bytes, Algorithm);
            Cipher c1 = Cipher.getInstance(Algorithm);
            c1.init(Cipher.ENCRYPT_MODE, deskey);
            encDataBytes = c1.doFinal(dataBytes);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return byte2hex(encDataBytes);
    }

    public byte[] HexString2Bytes(String hexstr) {
        byte[] b = new byte[hexstr.length() / 2];
        int j = 0;
        for (int i = 0; i < b.length; i++) {
            char c0 = hexstr.charAt(j++);
            char c1 = hexstr.charAt(j++);
            b[i] = (byte) ((parse(c0) << 4) | parse(c1));
        }
        return b;
    }

    private static int parse(char c) {
        if (c >= 'a')
            return (c - 'a' + 10) & 0x0f;
        if (c >= 'A')
            return (c - 'A' + 10) & 0x0f;
        return (c - '0') & 0x0f;
    }

    public String byte2hex(byte[] b) {
//      final StringBuilder stringBuilder = new StringBuilder(b.length);
//      for (byte byteChar : b)
//          stringBuilder.append(String.format("%02X", byteChar));
//      return stringBuilder.toString();
      char[] hexChar = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
      String temp = "";
      for (int i = 0; i < b.length; i++) {
          int pose = b[i];
          pose = pose >= 0 ? pose : pose + 256;
          temp += hexChar[pose / 16]+""+hexChar[pose % 16];
      }
      return temp;
  }
    
    
    public String byte2hex2(byte[] b) {
        final StringBuilder stringBuilder = new StringBuilder(b.length);
        //for (byte byteChar : b)
            //stringBuilder.append(String.format("%02X", byteChar));
        return stringBuilder.toString();
        
        /*
        String temp = "";
        //for(byte by : b)
           // sb.append(String.format("%20X",by));
        for(int i =0;i<b.length;i++){
        	// sb.append(String.format("%20X",b[i]));
        	temp += b[i];
        }

        return temp;
        
        */
    }
   
    
    
    public int test(){
    	System.out.println(111111);
    	return 1;
    	
    }
    
    public byte[] mac(String data) {
		byte[] dlkBytes = HexString2Bytes(seslk);
		String tmpString = "";
		if (30 == data.length())
			tmpString = data + "80";
		else if (36 == data.length())
			tmpString = data + "800000000000";

		byte[] dataBytes = HexString2Bytes(tmpString);
		byte[] encDataBytes = new byte[dataBytes.length];

		byte[] iv = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
		IvParameterSpec ips = new IvParameterSpec(iv);

		try {
			Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
			String Algorithm = "DES/CBC/NoPadding";

			SecretKey deskey = new SecretKeySpec(dlkBytes, Algorithm);
			Cipher c1 = Cipher.getInstance(Algorithm);
			c1.init(Cipher.ENCRYPT_MODE, deskey, ips);
			encDataBytes = c1.doFinal(dataBytes);
		} catch (Exception e) {
			e.printStackTrace();
		}
		byte[] retBytes = new byte[4];
		if (30 == data.length())
			System.arraycopy(encDataBytes, 8, retBytes, 0, 4);
		else if (36 == data.length())
			System.arraycopy(encDataBytes, 16, retBytes, 0, 4);
		return retBytes;
	}
    
    
    public String initForLoadProcess(String data,String money) {
		iccBalance = data.substring(0, 8);
		tranSequence = data.substring(8, 12);
		iccRandom = data.substring(16, 24);
		iccMac1 = data.substring(24, 32);
		
		//money ="00000064";

		
		random = iccRandom + tranSequence + "8000";
		mac1Src = iccBalance + money + transactionId + terminalNum;

		seslk = enc3Des(random);

		String tmpMac = byte2hex(mac(mac1Src));
		
		
		//load()
		String loadCmd = "805200000B20010101235959";
		mac2Src = money + "0211223344556620010101235959";
		byte[] mac2 = mac(mac2Src);
		loadCmd += byte2hex(mac2);
		
		return loadCmd;
		
		
		
		

	}
    
    
    
    
    
    
}
