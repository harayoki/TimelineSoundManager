/*

USAGE
・タイムラインにフレームラベル名とともにサウンド設定がしてあるMovieC1lipを用意する
　MovieC1lipは外部から読み込んだものでも、ライブラリからnewしたものでもよい。
　1フレーム名にはサウンド、ラベルとも何も設定せず、stop()だけ記述してある事を想定。
　サウンド設定は2フレーム以降で。
・applyClipへ引数として渡す。
・ラベル名を引数にplaySeを呼び出す

注意
・iOSで外部から読み込んだswfを使う場合、その中のscript実行が無効になるので
　読み込んだ側のscriptでstopをかけてやるとよい。

*/

package net.harayoki.sound
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;

	/**
	 * iOSなどスマートフォンデバイス上ではSound::playを実行すると負荷が高いようなので
	 * タイムライン上のサウンドを鳴らす形式のサウンドエンジンを用意する。
	 * @author harayoki
	 */
	public class TimelineSoundManager
	{
		
		private var _soundInfo:Object;
		private var _enabled:Boolean = true;
		
		public function TimelineSoundManager()
		{
			_soundInfo  = {};
		}
		
		/**
		 * タイムラインにイベントサウンドが仕込まれたMovieClipを与えます
		 */
		public function applyClip(clip:MovieClip,volume:Number=1.0):void
		{
			
			clip.gotoAndStop(1);//iOSでは内部でstopが書いてあっても効かないので強制で止める
			
			var scene:Scene = clip.scenes[0];
			var frames:Vector.<FrameLabel> = Vector.<FrameLabel>(scene.labels);
			for(var i:int=0;i<frames.length;i++)
			{
				var id:String = frames[i].name;
				_soundInfo[id] = new Info(clip,id);
			}			
			clip.soundTransform = new SoundTransform(volume);
		}
		
		/**
		 * サウンドが再生可能か確認します
		 */
		public function hasSoundData(id:String):Boolean
		{
			return _soundInfo[id] ? true : false;
		}
		
		/**
		 * マネージャを有効にします
		 */
		public function setEnabled(b:Boolean):void
		{
			_enabled = b;			
		}
		
		/**
		 * マネージャが有効か調べます
		 */
		public function isEnabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * SEを再生します
		 */
		public function playSe(id:String):void
		{
			if(!_enabled) return;
			var info:Info = _soundInfo[id] as Info;
			if(!info) return;
			if(getTimer() - info.lastPlayed < info.noPlayWithin) return;
			info.clip.gotoAndStop(info.id);
			info.clip.gotoAndStop(1);
			info.lastPlayed = getTimer();
		}

		
	}
}
import flash.display.MovieClip;

internal class Info
{
	public var clip:MovieClip;
	public var id:String;
	public var volume:Number = 1.0;//現状は個別の音量調整は無効です
	public var lastPlayed:Number = 0;
	public var noPlayWithin:Number = 50;
	public function Info(clip:MovieClip,id:String,volume:Number=1.0)
	{
		this.clip = clip;
		this.id = id;
		this.volume = volume;
	}
	
}