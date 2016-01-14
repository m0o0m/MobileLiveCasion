import flash.utils.ByteArray;
import flash.utils.Endian;

/////////////////////////////////////////////////////////////////////////////////////////
//游戏标识

//通用游戏
const ID_PLAZA:uint=0;//大厅
//对战
const ID_B_SICHUAN_LAND:uint = 1;//斗地主
const ID_B_THREELEAF:uint=2;//扎金花
const ID_B_SHOWHAND:uint=3;//梭哈
const ID_B_DOUBLESPARROW:uint=4;//二人麻将
const ID_B_REDBATTLESPARROW:uint=5;//血战麻将
const ID_B_ERBAGANG:uint=6;//二八杠
const ID_B_EVERYBODYHAPPY:uint=7;//大家乐
const ID_B_GOBANG:uint=8;//5子棋
const ID_B_CHESS:uint=9;//象棋
const ID_B_TRICKSHOT:uint=10;//台球
const ID_B_TEXASPOKER:uint=11;//德洲扑克


/////////////////////////////////////////////////////////////////////////////////////////
//宏定义

const MAX_CHAIR:int=8;//最大游戏桌子
const MAX_CHAT_LEN:int=512;//聊天长度
const INVALID_TABLE:uint=int(-1) >>> 16;//无效桌子号
const INVALID_CHAIR:uint=int(-1) >>> 16;//无效椅子号


//端口定义
const PORT_PLAZA:int=8800;//大厅端口

//网络数据定义
const SOCKET_VER:int=68;//数据包版本
const SOCKET_PACKAGE:int=2048;
const SOCKET_BUFFER:int=30000;
const sizeof_DWORD:int=4;
//内核命令码
const MDM_KN_COMMAND:int=0;//内核命令
const SUB_KN_DETECT_SOCKET:int=1;//检测命令

//////////////////////////////////////////////////////////////////////////

//用户状态定义
const US_NULL:int=0x00;//没有状态
const US_FREE:int=0x01;//站立状态
const US_SIT:int=0x02;//坐下状态
const US_READY:int=0x03;//同意状态
const US_LOOKON:int=0x04;//旁观状态
const US_PLAY:int=0x05;//游戏状态
const US_OFFLINE:int=0x06;//断线状态

//长度宏定义
const NAME_LEN:int=32;//名字长度
const PASS_LEN:int=33;//密码长度

//用户等级
const USERLEVEL_GAMEUSER:int=5;//会员
//用户类型
const USERTYPE_GAME:int=0;//普通帐号
const USERTYPE_SUB:int=1;//子帐号
const USERTYPE_DEALER:int=2;//Dealer帐号
//客户端类型
const CLIENTTYPE_GAME:int=0;//游戏端
const CLIENTTYPE_MAN:int=1;//管理端
const CLIENTTYPE_SERVICE:int=2;//客户中心
const CLIENTTYPE_CONTROL:int=3;//控制端

//消息类型
const SMT_INFO:int=0x0001;//信息消息
const SMT_EJECT:int=0x0002;//弹出消息
const SMT_GLOBAL:int=0x0004;//全局消息
const SMT_CLOSE_ROOM:int=0x1000;//关闭房间
const SMT_INTERMIT_LINE:int=0x4000;//中断连接