<%
/* Zip/Unzip, Encrypt/Decrypt & Encode/Decode, administrator
 * v0.1
 * Xenxin@Ufqi.com
 * Sun Jul  1 09:40:17 UTC 2018
 */
%><%@page import="java.math.BigInteger,java.security.MessageDigest,
java.security.NoSuchAlgorithmException,java.io.UnsupportedEncodingException"%><%
%><%!
public static final class Zeea{
	//- variables
	public static final String Java_File_Default_Charset = "ISO-8859-1";
    public static final String Java_UTF8_Charset = "UTF-8";
	double ver = 0.1;

	//- constructor
	public Zeea(){
		//- @todo

	}

	//- methods, public
	public static String md5(String txt){
		return getMD(txt, "MD5");
	}
	
	//- sha1
	public static String sha1(String txt){
		return getMD(txt, "SHA-1");
	}
	
	//- sha256
	public static String sha256(String txt){
		return getMD(txt, "SHA-256");
	}
	
	//-sha512
	public static String sha512(String txt){
		return getMD(txt, "SHA-512");
	}
	
	//- methods, private
	private static String getMD(String txt, String hashType){
		String mdStr = "";
		try {
			MessageDigest md = MessageDigest.getInstance(hashType);
			byte[] array = md.digest(txt.getBytes("UTF-8"));
			StringBuffer sb = new StringBuffer();

			for(int i = 0; i < array.length; ++i) {
				sb.append(Integer.toHexString(array[i] & 255 | 256).substring(1, 3));
			}

			return mdStr=sb.toString();
		}
		catch (NoSuchAlgorithmException var6){
			return mdStr;
		}
		catch (UnsupportedEncodingException var7){
			return mdStr;
		}
	}
	
	/** 
     * @param encryptKey  密钥 
     * @param encryptText 签名内容 
     * @param encryptAlgorithm 签名算法 
     * @return 
     */  
    private static String encryptHAMC(String encryptKey, String encryptText, String encryptAlgorithm){   
        String hamcStr = "";
		try{
        	javax.crypto.SecretKey secretKey = new javax.crypto.spec.SecretKeySpec(encryptKey.getBytes("UTF-8"), encryptAlgorithm); 
            javax.crypto.Mac mac = javax.crypto.Mac.getInstance(secretKey.getAlgorithm()); 
            mac.init(secretKey);
            byte[] encryptBytes = mac.doFinal(encryptText.getBytes("UTF-8"));
            return byte2hex(encryptBytes);
        }
        catch (UnsupportedEncodingException e) {
			return hamcStr;
		}
		catch (NoSuchAlgorithmException e) {
			return hamcStr;
		}
		catch (java.security.InvalidKeyException e) {
			return hamcStr;
		} 
    }
	
    /*
     * byte array change to HexString
     */
    private static String byte2hex(byte[] b) {
       StringBuffer sb = new StringBuffer(b.length * 2);
       int v;
       for (int i = 0; i < b.length; i++) {
         v = b[i] & 0xff;
         if (v < 16) {
           sb.append('0');
         }
         sb.append(Integer.toHexString(v));
       }
       return sb.toString();
     }
    
    
   	//- hmacsha1
    public static String hmacsha1(String encryptKey, String encryptText){
    	return encryptHAMC(encryptKey, encryptText, "HmacSHA1");
    }
	
    //-Base64Encode
    public static String base64Encode(String txt){
        String enc = "";
        try{
            byte[] bytes = txt.getBytes(Zeea.Java_UTF8_Charset);
            enc = java.util.Base64.getEncoder().encodeToString(bytes);
        }
        catch(Exception ex1535){
            ex1535.printStackTrace();
        }
        return enc;
    }

    //-Base64Decode
    public static String base64Decode(String txt){
        String dec = "";
        try{
            byte[] bytes = java.util.Base64.getDecoder().decode(txt);
            dec = new String(bytes);
        }
        catch(Exception ex1535){
            ex1535.printStackTrace();
        }
        return dec;
    }

}
%>