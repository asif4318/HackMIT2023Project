////
////  API.swift
////  FinSight
////
////  Created by Asif Islam on 9/17/23.
////
//
//import Foundation
//import PythonKit
//import LangChain
//
//class LLM_API {
//    init() {
//        
//    }
//    
//    func getPythonInfo() {
//        PythonLibrary.useVersion(3, 10)
//        print(Python.version)
//    }
//    
//    func analyzeReceipt(receipt_data:String) -> String {
//        var output = ""
//        
//        let template =
//        """
//        You are a receipt analyzer that analyzes this receipt READING EACH ITEM BOUGHT, ITS COST, AND THE TOTAL. Keep it short and concise
//
//        %@
//        Human: %@
//        Assistant:
//        """
//
//        let prompt = PromptTemplate(input_variables: ["history", "human_input"], template: template)
//        
//        let chatgpt_chain = LLMChain(
//            llm: OpenAI(),
//            prompt: prompt,
//            parser: StrOutputParser(),
//            memory: ConversationBufferWindowMemory()
//        )
//        
//        Task {
//            var input = ["human_input": receipt_data]
//            var output = await chatgpt_chain.predict(args: input)
//            print(output["Answer"]!)
//            print("FINISHED ANALYZING RECEIPT")
//            return output["Answer"]!
//        }
//        
//        return output
//    }
//}
