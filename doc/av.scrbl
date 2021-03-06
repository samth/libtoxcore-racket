#lang scribble/doc
@(require "common.rkt")

@title[#:tag "av"]{Audio/Video}

@defmodule[libtoxcore-racket/av]

The functions in @racketmodname[libtoxcore-racket/av] pertain to Audio/Video interaction.

@section[#:tag "structs"]{Structs}

@defstruct[_ToxAvCSettings ([call_type integer?]
                                [video_bitrate integer?]
                                [video_width integer?]
                                [video_height integer?]
                                [audio_bitrate integer?]
                                [audio_frame_duration integer?]
                                [audio_sample_rate integer?]
                                [audio_channels integer?])]{
  @racket[call_type] is a @racket[_ToxAvCallType] enum value.
  
  @racket[video_bitrate] is in kbit/s
  
  @racket[video_width] is in px
  
  @racket[video_height] is in px
  
  @racket[audio_bitrate] is in bits/s
  
  @racket[audio_frame_duration] is in ms
  
  @racket[audio_sample_rate] is in Hz
}

@section[#:tag "procedures"]{Procedures}

@defproc[(ToxAVCallback [agent cpointer?] [call-index integer?]
                        [arg cpointer?]) void?]{
  Commonly reused callback form.
}

@defproc[(ToxAvAudioCallback [agent cpointer?] [call-index integer?]
                             [pcm bytes?] [size integer?]
                             [data cpointer?]) void?]{
  Commonly reused audio callback form.
}

@defproc[(ToxAvVideoCallback [agent cpointer?] [call-index integer?]
                             [img bytes?] [data cpointer?]) void?]{
  Commonly reused video callback form.
}

@defproc[(av-new [messenger _Tox-pointer] [max_calls integer?]) _ToxAv-pointer]{
  Start new A/V session. There can only be one session at the time.
  If you register more it will result in undefined behaviour.
  
  return @racket[_ToxAv-pointer]
  
  return NULL On error.
}

@defproc[(av-kill! [av _ToxAv-pointer]) void?]{
  Remove A/V session.
  
  return void
}

@defproc[(toxav-do-interval [av _ToxAv-pointer]) integer?]{
  Returns the amount of time you should sleep before running @tt{tox-do}
  again. If there is no call at the moment, it returns 200.
}

@defproc[(toxav-do [av _ToxAv-pointer]) void?]{
  Main loop for the session. Best called right after @racket[tox-do].
}

@defproc[(callback-callstate [av _ToxAv-pointer] [callback procedure?]
                             [id integer?] [userdata cpointer? #f]) void?]{
  Register callback for call state.
 
  @racket[callback] is the ToxAvCallback procedure.
  
  @racket[id] is one of the @racket[ToxAvCallbackID] values
  
  return void
}

@defproc[(callback-audio-recv [av _ToxAv-pointer] [callback procedure?]
                              [userdata cpointer? #f])
         void?]{
  Register callback for receiving audio data.
  
  @racket[callback] is in the ToxAvAudioCallback procedure.
  
  return void
}

@defproc[(callback-video-recv [av _Tox-Av-pointer] [callback procedure?]) void?]{
  Register callback for receiving video data.
  
  @racket[callback] is in the ToxAvAudioCallback procedure.
  
  return void
}

@defproc[(av-call [av _ToxAv-pointer]
                  [call-index bytes?]
                  [friend-id integer?]
                  [csettings cpointer?]
                  [ringing-seconds integer?]) integer?]{
  Call user. Use its @racket[friend-id].
}

@defproc[(av-hangup [av  _ToxAv-pointer]
                    [call-index integer?]) (or/c boolean? integer?)]{
  Hangup active call.
 
  return @racket[#t] on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(av-answer [av _ToxAv-pointer]
                    [call-index integer?]
                    [csettings cpointer?]) (or/c boolean? integer?)]{
  Answer incoming call.
 
  return @racket[#t] on success.
  
  return @racket[_ToxAvError] On error.
}

@defproc[(av-reject [av _ToxAv-pointer]
                 [call-index integer?]
                 [reason string?]) (or/c boolean? integer?)]{
  Reject incoming call.
 
  Optional reason. Set NULL if none.
  
  return @racket[#t] on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(av-change-settings [av _ToxAv-pointer] [call-index integer?]
                             [csettings cpointer?]) integer?]{
  Notify peer that we are changing call settings.

  return 0 on success

  return @racket[_ToxAvError]
}

@defproc[(av-cancel [av _ToxAv-pointer]
                    [call-index integer?]
                           [peer-id integer?]
                           [reason string?]) integer?]{
  Cancel outgoing request.
  
  Optional reason.
  
  return 0 on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(av-stop-call [av _ToxAv-pointer]
                       [call-index integer?]) integer?]{
  Terminate transmission. Note that transmission will be terminated without
  informing remote peer.
 
  return 0 on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(prepare-transmission [av _ToxAv-pointer]
                               [call-index integer?]
                               [support-video? boolean?]) integer?]{
  Allocates transmission data. Must be called before calling toxav_prepare_* and toxav_send_*.

  Also, it must be called when call is started
}

@defproc[(kill-transmission [av _ToxAv-pointer]
                            [call-index integer?]) integer?]{
  Call this at the end of the transmission.
  
  return 0 on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(prepare-video-frame [av _ToxAv-pointer]
                              [call-index integer?]
                              [dest cpointer?]
                              [dest-max integer?]
                              [input bytes?]) integer?]{
  Encode video frame.
}

@defproc[(send-video [av _ToxAv-pointer]
                     [call-index integer?]
                     [frame cpointer?]
                     [frame-size integer?]) integer?]{
  Encode and send video packet.
  
  return 0 on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(prepare-audio-frame [av _ToxAv-pointer]
                              [call-index integer?]
                              [dest cpointer?]
                              [dest-max integer?]
                              [frame cpointer?]
                              [frame-size integer?]) integer?]{
  Encode audio frame.
  
  return >0 on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(send-audio [av _ToxAv-pointer]
                     [call-index inteder?]
                     [frame bytes?]
                     [frame-size integer?]) integer?]{
  Send audio frame.
  
  @racket[frame] is the frame (raw 16 bit signed pcm with AUDIO_CHANNELS channels audio.)
  
  @racket[frame-size] is its size in number of frames/samples (one frame/sample is 16
  bits or 2 bytes). @racket[frame-size] should be AUDIO_FRAME_SIZE.
  
  return 0 on success.
  
  return @racket[_ToxAvError] on error.
}

@defproc[(get-peer-csettings [av _ToxAv-pointer]
                             [call-index integer?]
                             [peer integer?]) list?]{
  Get peer transmission type. It can either be audio or video.
 
  return a list containing @racket[_ToxAvCallType] and a csettings cpointer on success.
  
  return a list containing @racket[_ToxAvError] on error.
}

@defproc[(get-peer-id [av _ToxAv-pointer]
                      [call-index integer?]
                      [peer integer?]) integer?]{
  Get id of peer participating in conversation
  
  return @racket[_ToxAvError] when there is no peer id
}

@defproc[(get-call-state [av _ToxAv-pointer] [call-index integer?]) integer?]{
  Get current call state.

  returns integer from @racket[_ToxAvCallState].
}

@defproc[(capability-supported? [av _ToxAv-pointer]
                                [call-index integer?]
                                [capability integer?]) boolean?]{
  Is a certain capability supported?
  
  @racket[capability] is on of @racket[ToxAvCapabilities].
}

@defproc[(av-get-tox [av _ToxAv-pointer]) _Tox-pointer]{
  Return the @racket[_Tox-pointer] being used with the @racket[_ToxAv-pointer].
}

@defproc[(get-active-calls [av _ToxAv-pointer]) integer?]{
  Returns number of active calls or -1 on error.
}

@defproc[(add-av-groupchat [tox _Tox-pointer]
                           [audio-callback procedure?]
                           [userdata cpointer? #f]) integer?]{
  Create a new ToxAV group.

  @racket[audio-callback] is in the form @racket[(audio-callback tox groupnumber
                                                                peernumber pcm
                                                                samples channels
                                                                sample-rate userdata)]
  where @racket[pcm] is a byte string of the size
        @racket[(* samples channels (ctype-sizeof _int16_t))].

  return @racket[groupnumber] on success.

  return -1 on failure.
}

@defproc[(join-av-groupchat [tox _Tox-pointer]
                            [friendnumber integer?]
                            [data cpointer?]
                            [data-len integer?]
                            [audio-callback procedure?]
                            [userdata cpointer? #f]) integer?]{
  Join AV group (you need to have been invited first).

  @racket[audio-callback] is in the form @racket[(audio-callback tox groupnumber peernumber
                                                                 pcm samples channels
                                                                 sample-rate userdata)]
  where @racket[pcm] is of size @racket[(* samples channels)].

  return @racket[groupnumber] on success.

  return -1 on failure.
}

@defproc[(group-send-audio [tox _Tox-pointer] [groupnumber integer?] [pcm bytes?]
                           [samples integer?] [channels integer?] [sample-rate integer?])
         integer?]{
  Send audio to the groupchat.

  Note that @racket[pcm] is a byte string of the size
            @racket[(* samples channels (ctype-sizeof _int16_t))].

  Valid number of samples are
  ((sample rate) * (audio length (Valid ones are: 2.5, 5, 10, 20, 40 or 60 ms)) / 1000)

  Valid number of channels are 1 or 2.
  
  Valid sample rates are 8000, 12000, 16000, 24000, or 48000.

  Recommended values are: samples = 960, channels = 1, sample_rate = 48000

  return 0 on success

  return -1 on failure.
}
